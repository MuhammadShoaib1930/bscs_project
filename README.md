📱 BSCS Smart Home Automation System (Flutter + ESP8266)
📌 Project Description (GitHub “About” Section)

A Smart Home Automation System built using Flutter and ESP8266.
The system allows users to control relays, servos (door/window), and monitor gas sensor values using a Flutter Android application with Firebase integration.
Offline control is supported via ESP8266 Access Point mode with a built-in web interface.

📑 README.md (Complete & Logical)
🔹 1. Introduction

This project is a Smart Home Automation System developed as part of a BSCS academic project.
It integrates Flutter (Android app) with ESP8266 microcontroller to control home appliances and monitor sensor data.

The system supports:

Online mode using Firebase Realtime Database

Offline mode using ESP8266 WiFi Access Point and web server

🔹 2. System Architecture

The project consists of three main layers:

Mobile Application (Flutter)

Backend (Firebase Realtime Database)

Hardware Layer (ESP8266 + Sensors + Relays + Servos)

🔁 Data Flow
Flutter App → Firebase → ESP8266 → Hardware
Hardware → ESP8266 → Firebase → Flutter App

🔹 3. Features
📱 Flutter Application

Android APK built using Flutter

Clean UI with multiple modules

Real-time device control

State management using BLoC pattern

Firebase integration

🔌 ESP8266 Hardware Control

7 Relay outputs (appliances)

2 Servo motors (Door & Window)

Gas sensor monitoring

EEPROM-based WiFi credential storage

🌐 Offline Mode

ESP8266 creates its own WiFi AP

Built-in web interface

Relay & servo control via browser

WiFi setup page

🔹 4. Folder Structure
📂 Flutter Application
📁 lib
    📄 app.dart
    📄 main.dart
    📁 bloc
      📁 settings
        📄 settings_bloc.dart
        📄 settings_event.dart
        📄 settings_state.dart
    📁 constants
      📄 app_constants.dart
    📁 hive
      📄 hive_manager.dart
      📄 settings_model.dart
      📄 settings_model.g.dart
    📁 routes
      📄 app_routes.dart
    📁 theme
      📄 app_theme.dart
    📁 ui
      📁 gas
        📁 bloc
          📄 gas_bloc.dart
          📄 gas_event.dart
          📄 gas_state.dart
        📄 gas_page.dart
      📁 home
        📄 home_page.dart
      📁 relays
        📁 bloc
          📄 relays_bloc.dart
          📄 relays_event.dart
          📄 relays_state.dart
        📄 relays_page.dart
      📁 servo
        📁 bloc
          📄 servo_bloc.dart
          📄 servo_event.dart
          📄 servo_state.dart
        📄 servo_page.dart
      📁 splash
        📄 splash_screen.dart
      📁 widgets
        📄 drawer_widget.dart
📁 assets
    📁 image
        📄 app_icon.png
📂 ESP8266 Firmware
esp8266/
 └── esp8266.ino
 
📄 pubspec.yaml
  package used
    cupertino_icons: ^1.0.8
    firebase_core: ^4.3.0
    firebase_database: ^12.1.1
    flutter_bloc: ^9.1.1
    equatable: ^2.0.7
    hive_flutter: ^1.1.0
    path_provider: ^2.1.5
    http: ^1.6.0
    hive: ^2.2.3
    build_runner: ^2.4.13
    hive_generator: ^2.0.1

[√] Flutter (Channel stable, 3.35.7, on Microsoft Windows [Version 10.0.26200.7462], locale en-US) [555ms]
    • Flutter version 3.35.7 on channel stable at C:\program_files\flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision adc9010625 (3 months ago), 2025-10-21 14:16:03 -0400
    • Engine revision 035316565a
    • Dart version 3.9.2
    • DevTools version 2.48.0
    • Feature flags: enable-web, enable-linux-desktop, enable-macos-desktop, enable-windows-desktop, enable-android, enable-ios,
      cli-animations, enable-lldb-debugging

[√] Windows Version (Windows 11 or higher, 25H2, 2009) [2.1s]

[√] Android toolchain - develop for Android devices (Android SDK version 36.1.0) [3.1s]
    • Android SDK at C:\Users\shoai\AppData\Local\Android\sdk
    • Emulator version 36.2.12.0 (build_id 14214601) (CL:N/A)
    • Platform android-36, build-tools 36.1.0
    • Java binary at: C:\Program Files\Java\jdk-17\bin\java
      This JDK is specified in your Flutter configuration.
      To change the current JDK, run: `flutter config --jdk-dir="path/to/jdk"`.
    • Java version Java(TM) SE Runtime Environment (build 17.0.15+9-LTS-241)
    • All Android licenses accepted.

[√] Android Studio (version 2025.1.4) [18ms]
    • Android Studio at C:\Program Files\Android\Android Studio
    • Flutter plugin can be installed from:
       https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
       https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 21.0.8+-14018985-b1038.68)

[√] VS Code (version 1.107.1) [15ms]
    • VS Code at C:\Users\shoai\AppData\Local\Programs\Microsoft VS Code
    • Flutter extension version 3.126.0


🔹 5. Technologies Used
🧑‍💻 Software

Flutter (Dart)

Firebase Realtime Database

BLoC State Management

Hive (Local Storage)

🔧 Hardware

ESP8266 NodeMCU

Relay Module (7 Channels)

Servo Motors

Gas Sensor (MQ Series)

🔹 6. Dependencies (Flutter)
firebase_core
firebase_database
flutter_bloc
equatable
hive
hive_flutter
http
path_provider

Dev Dependencies
build_runner
hive_generator

🔹 7. ESP8266 Logic Overview
🔸 Online Mode

Connects to saved WiFi

Syncs relay & servo states from Firebase

Sends gas sensor data to Firebase

🔸 Offline Mode

Automatically switches to AP mode if WiFi fails

Hosts a web server on 192.168.4.1

Allows:

Relay control

Servo angle control

WiFi credential setup

🔹 8. How to Build Android APK
flutter clean
flutter pub get
flutter build apk --release


APK output:

build/app/outputs/flutter-apk/app-release.apk

🔹 9. How to Upload ESP8266 Code

Open esp8266.ino in Arduino IDE

Select NodeMCU 1.0 (ESP-12E Module)

Select correct COM port

Upload code

🔹 10. Future Improvements

User authentication

Push notifications

Energy monitoring

Voice control

OTA updates for ESP8266

🔹 11. Author

Muhammad Shoaib
BSCS Student
GitHub: MuhammadShoaib1930

🔹 12. License

This project is for educational purposes only.

✅ Why this README is GOOD (Exam + GitHub)

✔ Clear architecture
✔ Logical flow
✔ Professional headings
✔ Explains both Flutter & ESP8266
✔ Easy for examiner to understand
