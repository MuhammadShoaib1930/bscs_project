#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Firebase_ESP_Client.h>
#include <WiFiManager.h>
#include <Servo.h>
#include <LittleFS.h>

/* ===================== PINS ===================== */
#define RELAY1_PIN 5
#define RELAY2_PIN 4
#define RELAY3_PIN 0
#define RELAY4_PIN 2
#define EXHAUST_PIN 14
#define DOOR_SERVO_PIN 12
#define WIN_SERVO_PIN 13
#define ELEC_PIN 16
#define GAS_PIN A0

/* =================== FIREBASE =================== */
#define API_KEY "AIzaSyDAXNldDqXCjQ7DN4ELNyOyLn72jJxokGY"
#define DATABASE_URL "https://bscsproject-default-rtdb.firebaseio.com/"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

/* =================== OBJECTS =================== */
ESP8266WebServer server(80);
Servo doorServo;
Servo windowServo;

/* =================== STATE =================== */
struct RelayState {
  bool status = 0;          // ON/OFF
  int power_watt = 100;     // User provided power in W
  float target_kwh = 1.0;   // Target energy in kWh
  unsigned long on_time = 0; // Total ON time in ms
  unsigned long last_on = 0; // Last ON timestamp
  String start_time = "00:00"; // Scheduled start
  String end_time = "23:59";   // Scheduled end
  float consumed_kwh = 0;      // Energy consumed
};

struct SmartState {
  RelayState relay[4];
  int door = 0;
  int window = 0;
  int exhaust = 0;
  bool gasRisk = false;
  int lastExhaustUser = 0;
  int lastDoorUser = 0;
  int lastWindowUser = 0;
  int gasThreshold = 400; // default threshold
  unsigned long lastUpdate = 0;
  int gasValue = 0;
} state;

bool offlinePending = false;
bool firebaseReady = false;

/* =================== FILES =================== */
#define STATE_FILE "/state.txt"
#define QUEUE_FILE "/queue.txt"

/* =================== HELPERS =================== */
void log(String msg){ Serial.println(msg); }

// Convert HH:MM to minutes
int parseTime(String t){
  int h = t.substring(0, t.indexOf(':')).toInt();
  int m = t.substring(t.indexOf(':')+1).toInt();
  return h*60 + m;
}

// Check if current time is within schedule
bool inSchedule(String start, String end){
  time_t now_sec = millis()/1000;
  int now_h = (now_sec/3600)%24;
  int now_m = (now_sec/60)%60;
  int now_min = now_h*60 + now_m;
  int s = parseTime(start);
  int e = parseTime(end);
  return (now_min >= s && now_min <= e);
}

/* =================== FILE SYSTEM =================== */
void saveState(){
  File f = LittleFS.open(STATE_FILE, "w");
  if(!f) return;

  for(int i=0;i<4;i++){
    f.printf("%d,%d,%.2f,%lu,%lu,%s,%s,%.3f\n",
      state.relay[i].status, state.relay[i].power_watt, state.relay[i].target_kwh,
      state.relay[i].on_time, state.relay[i].last_on,
      state.relay[i].start_time.c_str(), state.relay[i].end_time.c_str(),
      state.relay[i].consumed_kwh);
  }
  f.printf("%d,%d,%d,%d,%lu,%d\n",
    state.door, state.window, state.exhaust,
    state.lastDoorUser, state.lastWindowUser, state.lastExhaustUser,
    state.gasThreshold, state.lastUpdate);
  f.close();
  log("[FS] State saved");
}

void loadState(){
  if(!LittleFS.exists(STATE_FILE)) return;
  File f = LittleFS.open(STATE_FILE, "r");
  if(!f) return;

  for(int i=0;i<4;i++){
    char buf[64]; f.readBytesUntil('\n', buf, sizeof(buf));
    sscanf(buf,"%d,%d,%f,%lu,%lu,%[^,],%[^,],%f",
      &state.relay[i].status, &state.relay[i].power_watt, &state.relay[i].target_kwh,
      &state.relay[i].on_time, &state.relay[i].last_on,
      buf, buf+16, &state.relay[i].consumed_kwh);
    state.relay[i].start_time = String(buf);
    state.relay[i].end_time = String(buf+16);
  }
  f.close();
  log("[FS] State loaded");
}

void markOffline(){
  offlinePending = true;
  File f = LittleFS.open(QUEUE_FILE,"w");
  f.print("1");
  f.close();
  log("[QUEUE] Marked offline changes");
}

void clearOffline(){
  offlinePending = false;
  LittleFS.remove(QUEUE_FILE);
  log("[QUEUE] Offline queue cleared");
}

/* =================== HARDWARE =================== */
void applyHardware(){
  digitalWrite(RELAY1_PIN,state.relay[0].status);
  digitalWrite(RELAY2_PIN,state.relay[1].status);
  digitalWrite(RELAY3_PIN,state.relay[2].status);
  digitalWrite(RELAY4_PIN,state.relay[3].status);
  doorServo.write(state.door);
  windowServo.write(state.window);
  analogWrite(EXHAUST_PIN,state.exhaust);
}

/* =================== WIFI =================== */
void connectWiFi(String ssid = "", String pass = ""){
  WiFiManager wm;
  if(ssid != "" && pass != ""){
    WiFi.begin(ssid, pass);
    int count=0;
    while(WiFi.status()!=WL_CONNECTED && count<20){ delay(500); count++; }
    if(WiFi.status()==WL_CONNECTED){ log("[WIFI] Connected via Firebase credentials"); return; }
  }
  if(WiFi.status()!=WL_CONNECTED){
    log("[WIFI] Starting config portal");
    if(!wm.autoConnect("SmartHome-Setup","12345678")) ESP.restart();
  }
  log("[WIFI] Connected: "+WiFi.SSID());
}

/* =================== FIREBASE =================== */
void connectFirebase(){
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  Firebase.signUp(&config,&auth,"","");
  Firebase.begin(&config,&auth);
  Firebase.reconnectWiFi(true);
  firebaseReady = Firebase.ready();
  log(firebaseReady ? "[FIREBASE] Connected" : "[FIREBASE] Failed");
}

/* =================== ENERGY MANAGEMENT =================== */
void updateRelayEnergy(int i){
  RelayState &r = state.relay[i];

  if(r.status){
    unsigned long now = millis();
    if(r.last_on>0) r.on_time += now - r.last_on;
    r.last_on = now;
    r.consumed_kwh = (r.power_watt * r.on_time / 3600000.0) / 1000.0; // kWh
    if(r.consumed_kwh >= r.target_kwh){
      r.status = 0; // Turn OFF relay
      markOffline();
    }
  } else r.last_on = 0;
}

void scheduleRelays(){
  for(int i=0;i<4;i++){
    RelayState &r = state.relay[i];
    // Only allow ON if within schedule and under target
    if(inSchedule(r.start_time,r.end_time) && r.consumed_kwh < r.target_kwh){
      r.status = 1;
    } else r.status = 0;
    updateRelayEnergy(i);
  }
  applyHardware();
}

/* =================== SEND STATE =================== */
void sendStateToFirebase(){
  if(!firebaseReady) return;
  unsigned long now = millis();
  if(now - state.lastUpdate < 500) return;

  for(int i=0;i<4;i++){
    Firebase.RTDB.setBool(&fbdo,"/relay/r"+String(i+1)+"/status",state.relay[i].status);
    Firebase.RTDB.setInt(&fbdo,"/relay/r"+String(i+1)+"/power_watt",state.relay[i].power_watt);
    Firebase.RTDB.setFloat(&fbdo,"/relay/r"+String(i+1)+"/target_kwh",state.relay[i].target_kwh);
    Firebase.RTDB.setFloat(&fbdo,"/relay/r"+String(i+1)+"/consumed_kwh",state.relay[i].consumed_kwh);
    Firebase.RTDB.setString(&fbdo,"/relay/r"+String(i+1)+"/start_time",state.relay[i].start_time);
    Firebase.RTDB.setString(&fbdo,"/relay/r"+String(i+1)+"/end_time",state.relay[i].end_time);
  }

  Firebase.RTDB.setInt(&fbdo,"/door",state.door);
  Firebase.RTDB.setInt(&fbdo,"/window",state.window);
  Firebase.RTDB.setInt(&fbdo,"/exhaust",state.exhaust);
  Firebase.RTDB.setBool(&fbdo,"/gas/risk",state.gasRisk);
  Firebase.RTDB.setInt(&fbdo,"/gas/value",state.gasValue);

  clearOffline();
  state.lastUpdate = now;
  log("[SYNC] Local → Firebase complete");
}

/* =================== SENSORS =================== */
void gasCheck(){
  state.gasValue = analogRead(GAS_PIN);

  if(firebaseReady){
    int t;
    if(Firebase.RTDB.getInt(&fbdo,"/gas/threshold")) t = fbdo.intData();
    else t = state.gasThreshold;
    state.gasThreshold = t;
  }

  bool risk = state.gasValue > state.gasThreshold;
  if(risk != state.gasRisk){ state.gasRisk = risk; markOffline(); }

  if(state.gasRisk){
    state.door = 90; state.window = 90;
    state.exhaust = map(state.gasValue,state.gasThreshold,1023,200,1023);
  } else {
    state.door = state.lastDoorUser; state.window = state.lastWindowUser;
    state.exhaust = state.lastExhaustUser;
  }
  applyHardware();
}

/* =================== SETUP =================== */
void setup(){
  Serial.begin(115200); log("[BOOT] ESP8266 Starting");

  pinMode(RELAY1_PIN,OUTPUT); pinMode(RELAY2_PIN,OUTPUT);
  pinMode(RELAY3_PIN,OUTPUT); pinMode(RELAY4_PIN,OUTPUT);
  pinMode(EXHAUST_PIN,OUTPUT);

  doorServo.attach(DOOR_SERVO_PIN); windowServo.attach(WIN_SERVO_PIN);

  LittleFS.begin(); loadState(); applyHardware();

  String ssid="", pass="";
  if(Firebase.RTDB.getString(&fbdo,"/wifi/ssid")) ssid=fbdo.stringData();
  if(Firebase.RTDB.getString(&fbdo,"/wifi/password")) pass=fbdo.stringData();

  connectWiFi(ssid,pass);

  if(WiFi.status()==WL_CONNECTED){
    connectFirebase();
    if(LittleFS.exists(QUEUE_FILE)) sendStateToFirebase();
  } else {
    WiFi.softAP("SmartHome-Offline","12345678");
    // Offline web server code omitted for brevity
  }
}

/* =================== LOOP =================== */
void loop(){
  if(WiFi.status()!=WL_CONNECTED){
    server.handleClient();
  } else {
    if(!firebaseReady){ connectFirebase(); if(firebaseReady && offlinePending) sendStateToFirebase(); }
    sendStateToFirebase();
  }

  scheduleRelays(); // Scheduling + energy management
  gasCheck();
  delay(300);
}
