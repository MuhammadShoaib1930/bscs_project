#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <Firebase_ESP_Client.h>
#include <Servo.h>
#include <EEPROM.h>

/* ===================== RELAY PINS ===================== */
#define RELAY1 5
#define RELAY2 4
#define RELAY3 0
#define RELAY4 2
#define RELAY5 14
#define RELAY6 15
#define RELAY7 16

int relayPins[] = {RELAY1, RELAY2, RELAY3, RELAY4, RELAY5, RELAY6, RELAY7};
bool relayState[7] = {0,0,0,0,0,0,0};

/* ===================== SERVO PINS ===================== */
#define DOOR_SERVO_PIN 12
#define WINDOW_SERVO_PIN 13

Servo doorServo;
Servo windowServo;

int doorAngle = 0;
int windowAngle = 0;
bool apModeActive = false;
/* ===================== GAS SENSOR ===================== */
#define GAS_SENSOR_PIN A0
int gasValue = 0;

/* =================== FIREBASE =================== */

#define API_KEY "AIzaSyDAXNldDqXCjQ7DN4ELNyOyLn72jJxokGY"
#define DATABASE_URL "https://bscsproject-default-rtdb.firebaseio.com/"


FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
bool firebaseReady = false;

/* =================== WEB SERVER =================== */
ESP8266WebServer server(80);

/* =================== WIFI EEPROM =================== */
char savedSSID[32];
char savedPASS[32];

void loadWiFiCreds() {
  EEPROM.begin(96);
  EEPROM.get(0, savedSSID);
  EEPROM.get(32, savedPASS);
  EEPROM.end();
}

void saveWiFiCreds(String ssid, String pass) {
  EEPROM.begin(96);
  ssid.toCharArray(savedSSID, 32);
  pass.toCharArray(savedPASS, 32);
  EEPROM.put(0, savedSSID);
  EEPROM.put(32, savedPASS);
  EEPROM.commit();
  EEPROM.end();
  ESP.restart(); // reboot after saving WiFi
}

/* =================== APPLY HARDWARE =================== */
void applyHardware() {
  Serial.println("---- RELAY & SERVO STATUS ----");
  for(int i=0;i<7;i++){
    digitalWrite(relayPins[i], relayState[i]);
    Serial.print("Relay "); Serial.print(i+1); Serial.println(relayState[i] ? " : ON" : " : OFF");
  }
  doorServo.write(doorAngle);
  windowServo.write(windowAngle);
  gasValue = analogRead(GAS_SENSOR_PIN);
  Serial.print("Door Angle: "); Serial.println(doorAngle);
  Serial.print("Window Angle: "); Serial.println(windowAngle);
  Serial.print("Gas Value: "); Serial.println(gasValue);
  Serial.println("-------------------------------");
}

/* =================== CONNECT WIFI =================== */
bool connectToWiFi() {
  loadWiFiCreds();
  if(strlen(savedSSID) == 0) return false;
  Serial.println("[WIFI] Connecting to saved SSID...");
  WiFi.mode(WIFI_STA);
  WiFi.begin(savedSSID, savedPASS);
  int retries = 0;
  while(WiFi.status() != WL_CONNECTED && retries < 20){
    delay(500);
    Serial.print(".");
    retries++;
  }
  Serial.println();
  if(WiFi.status() == WL_CONNECTED){
    Serial.println("[WIFI] Connected: " + WiFi.SSID());
    return true;
  } else return false;
}

/* =================== CONNECT FIREBASE =================== */
void connectFirebase() {
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  Firebase.signUp(&config, &auth, "", "");
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  firebaseReady = Firebase.ready();
  Serial.println(firebaseReady ? "[FIREBASE] Ready" : "[FIREBASE] Failed");
}

/* =================== READ FROM FIREBASE =================== */
void readFromFirebase() {
  if(!firebaseReady) return;

  for(int i=0;i<7;i++){
    String path = "/relay/r"+String(i+1);
    if(Firebase.RTDB.getBool(&fbdo, path)) relayState[i] = fbdo.boolData();
  }

  if(Firebase.RTDB.getInt(&fbdo, "/servo/door")) doorAngle = fbdo.intData();
  if(Firebase.RTDB.getInt(&fbdo, "/servo/window")) windowAngle = fbdo.intData();

  Firebase.RTDB.setInt(&fbdo, "/sensor/gas", gasValue);

  applyHardware();
}

/* =================== OFFLINE SERVER =================== */
void setupOfflineServer() {
  server.on("/", [](){
    String page = "<!DOCTYPE html><html><head>";
    page += "<meta name='viewport' content='width=device-width, initial-scale=1'>";
    page += "<title>ESP8266 Control</title>";
    page += "<style>";
    page += "body{font-family: Arial; background-color:#f0f2f5; text-align:center;}";
    page += "h2{color:#333;}";
    page += "h3{color:#555; margin-top:20px;}";
    page += "button{padding:10px 20px; margin:5px; font-size:16px; border:none; border-radius:5px; cursor:pointer;}";
    page += ".relay-on{background-color:#28a745; color:white;}";
    page += ".relay-off{background-color:#dc3545; color:white;}";
    page += "input[type=number]{width:60px; padding:5px; margin-right:5px;}";
    page += "input[type=text], input[type=password]{padding:5px; width:150px; margin:5px;}";
    page += "</style>";
    page += "<script>";
    page += "function toggleRelay(i){";
    page += "  var xhttp = new XMLHttpRequest();";
    page += "  xhttp.onreadystatechange = function(){";
    page += "    if(this.readyState == 4 && this.status == 200){";
    page += "      var btn = document.getElementById('r'+i);";
    page += "      if(btn.classList.contains('relay-on')){btn.className='relay-off'; btn.innerHTML='Relay '+i+': OFF';}";
    page += "      else{btn.className='relay-on'; btn.innerHTML='Relay '+i+': ON';}";
    page += "    }";
    page += "  };";
    page += "  xhttp.open('GET','/r'+i,true); xhttp.send();";
    page += "}";

    page += "function setDoor(){";
    page += "  var val = document.getElementById('doorVal').value;";
    page += "  var xhttp = new XMLHttpRequest();";
    page += "  xhttp.open('GET','/door?a='+val,true); xhttp.send();";
    page += "}";

    page += "function setWindow(){";
    page += "  var val = document.getElementById('windowVal').value;";
    page += "  var xhttp = new XMLHttpRequest();";
    page += "  xhttp.open('GET','/window?a='+val,true); xhttp.send();";
    page += "}";
    page += "</script></head><body>";

    page += "<h2>ESP8266 Offline Control / WiFi Setup</h2>";

    // WiFi Setup
    page += "<h3>Set WiFi</h3>";
    page += "<form action='/savewifi' method='get'>";
    page += "SSID: <input type='text' name='s' value='" + String(savedSSID) + "'><br>";
    page += "PASS: <input type='password' name='p' value='" + String(savedPASS) + "'><br>";
    page += "<input type='submit' value='Save WiFi' style='padding:10px 20px; margin-top:10px;'>";
    page += "</form><hr>";

    // Relays
    page += "<h3>Relays</h3>";
    for(int i=0;i<7;i++){
      String btnClass = relayState[i] ? "relay-on" : "relay-off";
      String btnText = relayState[i] ? "ON" : "OFF";
      page += "<button id='r"+String(i+1)+"' class='"+btnClass+"' onclick='toggleRelay(" + String(i+1) + ")'>Relay "+String(i+1)+": "+btnText+"</button>";
    }
    page += "<hr>";

    // Door Servo
    page += "<h3>Door Servo</h3>";
    page += "<input type='number' id='doorVal' min='0' max='180' value='" + String(doorAngle) + "'>";
    page += "<button onclick='setDoor()'>Set Door Angle</button><hr>";

    // Window Servo
    page += "<h3>Window Servo</h3>";
    page += "<input type='number' id='windowVal' min='0' max='180' value='" + String(windowAngle) + "'>";
    page += "<button onclick='setWindow()'>Set Window Angle</button><hr>";

    // Gas Sensor
    page += "<h3>Gas Sensor Value</h3>";
    page += "<p style='font-size:20px; color:#333;'>" + String(gasValue) + "</p>";

    page += "</body></html>";

    server.send(200,"text/html",page);
  });

  server.on("/savewifi", [](){
    String s = server.arg("s");
    String p = server.arg("p");
    if(s.length()>0) saveWiFiCreds(s,p);
    server.send(200,"text/plain","WiFi saved! Device will reboot.");
  });

  server.on("/door", [](){
    doorAngle = server.arg("a").toInt();
    applyHardware();
    server.send(200,"text/plain","Door angle set");
  });

  server.on("/window", [](){
    windowAngle = server.arg("a").toInt();
    applyHardware();
    server.send(200,"text/plain","Window angle set");
  });

  for(int i=0;i<7;i++){
    server.on("/r"+String(i+1), [i](){
      relayState[i] = !relayState[i];
      applyHardware();
      server.send(200,"text/plain","Relay toggled");
    });
  }

  server.begin();
  Serial.println("[SERVER] Offline server started, AP mode active");
}

void startAPMode() {
    if(apModeActive) return; // Already in AP mode
  apModeActive = true;
  WiFi.disconnect();
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(IPAddress(192,168,4,1), IPAddress(192,168,4,1), IPAddress(255,255,255,0));
  WiFi.softAP("ESP-Offline", "12345678");
  setupOfflineServer();
  Serial.println("[WIFI] Switched to AP Mode due to WiFi disconnect");
}


/* =================== SETUP =================== */
void setup() {
  Serial.begin(115200);

  for(int i=0;i<7;i++){
    pinMode(relayPins[i], OUTPUT);
    digitalWrite(relayPins[i], LOW);
    relayState[i] = false;
  }

  pinMode(GAS_SENSOR_PIN, INPUT);

  doorServo.attach(DOOR_SERVO_PIN);
  windowServo.attach(WINDOW_SERVO_PIN);

  applyHardware();

  if(!connectToWiFi()){ // AP + offline mode
    WiFi.mode(WIFI_AP);
    WiFi.softAPConfig(IPAddress(192,168,4,1), IPAddress(192,168,4,1), IPAddress(255,255,255,0));
    WiFi.softAP("ESP-Offline", "12345678");
    setupOfflineServer();
  } else { // Online mode
    connectFirebase();
  }
}

/* =================== LOOP =================== */
void loop() {
  // Check WiFi and Firebase
  if(WiFi.status() == WL_CONNECTED && firebaseReady){
    readFromFirebase();
  } else {
    // If WiFi disconnected, switch to AP mode dynamically
    if(WiFi.status() != WL_CONNECTED){
      startAPMode();
    }
    server.handleClient(); // Handle offline server requests
  }

  delay(500);
}
