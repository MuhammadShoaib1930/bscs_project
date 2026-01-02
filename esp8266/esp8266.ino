#include <ESP8266WebServer.h>
#include <ESP8266WiFi.h>
#include <Firebase_ESP_Client.h>
#include <LittleFS.h>
#include <Servo.h>
#include <WiFiManager.h>

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
    bool status = 0;            // ON/OFF
    int power_watt = 100;       // User provided power in W
    float target_kwh = 1.0;     // Target energy in kWh
    unsigned long on_time = 0;  // Total ON time in ms
    unsigned long last_on = 0;  // Last ON timestamp
    float consumed_kwh = 0;     // Energy consumed
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
    int gasThreshold = 400;  // default threshold
    int gasValue = 0;         // Added for persistence
    unsigned long lastUpdate = 0;
} state;

bool offlinePending = false;
bool firebaseReady = false;

/* =================== FILES =================== */
#define STATE_FILE "/state.txt"
#define QUEUE_FILE "/queue.txt"

/* =================== HELPERS =================== */
void log(String msg) { Serial.println(msg); }

void checkFirebaseWiFiUpdate() {
    static String lastSsid = "";
    static String lastPass = "";

    if (!firebaseReady) return;

    String fbSsid = "";
    String fbPass = "";

    if (Firebase.RTDB.getString(&fbdo, "/wifi/ssid"))
        fbSsid = fbdo.stringData();

    if (Firebase.RTDB.getString(&fbdo, "/wifi/password"))
        fbPass = fbdo.stringData();

    // First-time sync
    if (lastSsid == "" && lastPass == "") {
        lastSsid = fbSsid;
        lastPass = fbPass;
        return;
    }

    // If Firebase WiFi changed
    if (fbSsid != "" &&
        (fbSsid != lastSsid || fbPass != lastPass)) {

        log("[WIFI] Firebase WiFi changed → restarting");
        lastSsid = fbSsid;
        lastPass = fbPass;
        delay(1000);
        ESP.restart();
    }
}

/* =================== FILE SYSTEM =================== */
void saveState() {
    File f = LittleFS.open(STATE_FILE, "w");
    if (!f) return;

    for (int i = 0; i < 4; i++) {
        f.printf("%d,%d,%.2f,%lu,%lu,%.3f\n", state.relay[i].status,
                 state.relay[i].power_watt, state.relay[i].target_kwh,
                 state.relay[i].on_time, state.relay[i].last_on,
                 state.relay[i].consumed_kwh);
    }
    f.printf("%d,%d,%d,%d,%d,%d,%d,%d,%lu\n", state.door, state.window, state.exhaust,
             state.lastDoorUser, state.lastWindowUser, state.lastExhaustUser,
             state.gasThreshold, state.gasValue, state.lastUpdate);
    f.close();
    log("[FS] State saved");
}

void loadState() {
    if (!LittleFS.exists(STATE_FILE)) return;
    File f = LittleFS.open(STATE_FILE, "r");
    if (!f) return;

    for (int i = 0; i < 4; i++) {
        char buf[64];
        f.readBytesUntil('\n', buf, sizeof(buf));
        sscanf(buf, "%d,%d,%f,%lu,%lu,%f", &state.relay[i].status,
               &state.relay[i].power_watt, &state.relay[i].target_kwh,
               &state.relay[i].on_time, &state.relay[i].last_on,
               &state.relay[i].consumed_kwh);
    }
    char buf2[128];
    f.readBytesUntil('\n', buf2, sizeof(buf2));
    sscanf(buf2, "%d,%d,%d,%d,%d,%d,%d,%d,%lu", &state.door, &state.window, &state.exhaust,
           &state.lastDoorUser, &state.lastWindowUser, &state.lastExhaustUser,
           &state.gasThreshold, &state.gasValue, &state.lastUpdate);
    f.close();
    log("[FS] State loaded");
}

void markOffline() {
    offlinePending = true;
    saveState(); 
    File f = LittleFS.open(QUEUE_FILE, "w");
    f.print("1");
    f.close();
    log("[QUEUE] Marked offline changes");
}

void clearOffline() {
    offlinePending = false;
    LittleFS.remove(QUEUE_FILE);
    log("[QUEUE] Offline queue cleared");
}

/* =================== HARDWARE =================== */
void applyHardware() {
    digitalWrite(RELAY1_PIN, state.relay[0].status);
    digitalWrite(RELAY2_PIN, state.relay[1].status);
    digitalWrite(RELAY3_PIN, state.relay[2].status);
    digitalWrite(RELAY4_PIN, state.relay[3].status);
    doorServo.write(state.door);
    windowServo.write(state.window);
    analogWrite(EXHAUST_PIN, state.exhaust);
}

/* =================== WIFI =================== */
void connectWiFi(String ssid = "", String pass = "") {
    WiFiManager wm;
    if (ssid != "" && pass != "") {
        WiFi.begin(ssid, pass);
        int count = 0;
        while (WiFi.status() != WL_CONNECTED && count < 20) {
            delay(500);
            count++;
        }
        if (WiFi.status() == WL_CONNECTED) {
            log("[WIFI] Connected via Firebase credentials");
            return;
        }
    }
    if (WiFi.status() != WL_CONNECTED) {
        log("[WIFI] Starting config portal");
        if (!wm.autoConnect("SmartHome-Setup", "12345678")) ESP.restart();
    }
    log("[WIFI] Connected: " + WiFi.SSID());
}

/* =================== FIREBASE =================== */
void connectFirebase() {
    config.api_key = API_KEY;
    config.database_url = DATABASE_URL;

    Firebase.signUp(&config, &auth, "", "");
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
    firebaseReady = Firebase.ready();
    log(firebaseReady ? "[FIREBASE] Connected" : "[FIREBASE] Failed");
}

/* =================== ENERGY MANAGEMENT =================== */
void updateRelayEnergy(int i) {
    RelayState& r = state.relay[i];

    // Only calculate if electricity available
    if (digitalRead(ELEC_PIN) == HIGH && r.status) {
        unsigned long now = millis();
        if (r.last_on > 0) r.on_time += now - r.last_on;
        r.last_on = now;
        r.consumed_kwh =
            (r.power_watt * r.on_time / 3600000.0) / 1000.0;  // kWh
        if (r.consumed_kwh >= r.target_kwh) {
            r.status = 0;  // Turn OFF relay
            markOffline();
        }
    } else {
        r.last_on = 0;  // Reset if no electricity
    }
}

void scheduleRelays() {
    for (int i = 0; i < 4; i++) {
        updateRelayEnergy(i);
    }
    applyHardware();
}

/* =================== SEND STATE =================== */
void sendStateToFirebase() {
    if (!firebaseReady) return;
    unsigned long now = millis();
    if (now - state.lastUpdate < 500) return;

    for (int i = 0; i < 4; i++) {
        Firebase.RTDB.setBool(&fbdo, "/relay/r" + String(i + 1) + "/status",
                              state.relay[i].status);
        Firebase.RTDB.setInt(&fbdo, "/relay/r" + String(i + 1) + "/power_watt",
                             state.relay[i].power_watt);
        Firebase.RTDB.setFloat(&fbdo,
                               "/relay/r" + String(i + 1) + "/target_kwh",
                               state.relay[i].target_kwh);
        Firebase.RTDB.setFloat(&fbdo,
                               "/relay/r" + String(i + 1) + "/consumed_kwh",
                               state.relay[i].consumed_kwh);
    }

    Firebase.RTDB.setInt(&fbdo, "/door", state.door);
    Firebase.RTDB.setInt(&fbdo, "/window", state.window);
    Firebase.RTDB.setInt(&fbdo, "/exhaust", state.exhaust);
    Firebase.RTDB.setBool(&fbdo, "/gas/risk", state.gasRisk);
    Firebase.RTDB.setInt(&fbdo, "/gas/value", state.gasValue);

    clearOffline();
    state.lastUpdate = now;
    log("[SYNC] Local → Firebase complete");
}

/* =================== SENSORS =================== */
void gasCheck() {
    state.gasValue = analogRead(GAS_PIN);

    if (firebaseReady) {
        int t;
        if (Firebase.RTDB.getInt(&fbdo, "/gas/threshold"))
            t = fbdo.intData();
        else
            t = state.gasThreshold;
        state.gasThreshold = t;
    }

    bool risk = state.gasValue > state.gasThreshold;
    if (risk != state.gasRisk) {
        state.gasRisk = risk;
        markOffline();
    }

    if (state.gasRisk) {
        state.door = 90;
        state.window = 90;
        state.exhaust =
            map(state.gasValue, state.gasThreshold, 1023, 200, 1023);
    } else {
        state.door = state.lastDoorUser;
        state.window = state.lastWindowUser;
        state.exhaust = state.lastExhaustUser;
    }
    applyHardware();
}

/* =================== SETUP =================== */
void setup() {
    Serial.begin(115200);
    log("[BOOT] ESP8266 Starting");

    pinMode(RELAY1_PIN, OUTPUT);
    pinMode(RELAY2_PIN, OUTPUT);
    pinMode(RELAY3_PIN, OUTPUT);
    pinMode(RELAY4_PIN, OUTPUT);
    pinMode(EXHAUST_PIN, OUTPUT);
    pinMode(ELEC_PIN, INPUT_PULLUP);  // Added pull-up for stability

    doorServo.attach(DOOR_SERVO_PIN);
    windowServo.attach(WIN_SERVO_PIN);

    if (!LittleFS.begin()) {
        log("[FS] LittleFS mount failed!");
    }
    loadState();
    applyHardware();

    connectWiFi();  // Use WiFiManager for initial connection

    if (WiFi.status() == WL_CONNECTED) {
        connectFirebase();
        // Sync current WiFi to Firebase after connection
        Firebase.RTDB.setString(&fbdo, "/wifi/ssid", WiFi.SSID());
        Firebase.RTDB.setString(&fbdo, "/wifi/password", WiFi.psk());

        if (LittleFS.exists(QUEUE_FILE)) sendStateToFirebase();
    } else {
        WiFi.softAP("general-Offline", "12345678");
        // Offline web server setup (example - add your routes here)
        server.on("/", []() { server.send(200, "text/plain", "Offline Mode"); });
        server.begin();
        log("[SERVER] Offline server started");
    }
}

/* =================== LOOP =================== */
void loop() {
    if (WiFi.status() != WL_CONNECTED) {
        server.handleClient();
    } else {
        // Turn off AP mode if WiFi is connected
        if (WiFi.softAPgetStationNum() > 0) {  // Check if AP is active
            WiFi.softAPdisconnect(true);
            log("[AP] AP mode turned off due to WiFi connection");
        }
        if (!firebaseReady) {
            connectFirebase();
            if (firebaseReady && offlinePending) sendStateToFirebase();
        }
        sendStateToFirebase();
        checkFirebaseWiFiUpdate();
    }

    scheduleRelays();  // Energy management only if electricity available
    gasCheck();
    delay(300);
}
