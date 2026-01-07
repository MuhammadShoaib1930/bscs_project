📱 BSCS Smart Home Automation System

Flutter + ESP8266

📌 Project Overview

A Smart Home Automation System built using Flutter and ESP8266.
The system allows users to control relays, operate servo-based doors/windows, and monitor gas sensor data through an Android application.

It supports:

Online control via Firebase Realtime Database

Offline control using ESP8266 WiFi Access Point with a built-in web interface

This project was developed as part of a BSCS academic project, but it is designed to be extendable and open for community contributions.

🧩 Key Objectives

Automate home appliances using a mobile app

Enable real-time monitoring and control

Support offline usage without internet

Use clean architecture and scalable state management

🏗 System Architecture
🔹 Application Layers

Mobile Application – Flutter (Android)

Backend – Firebase Realtime Database

Hardware Layer – ESP8266 + Sensors + Relays + Servos

🔁 Data Flow
Flutter App → Firebase → ESP8266 → Hardware
Hardware → ESP8266 → Firebase → Flutter App

✨ Features
📱 Flutter Application

Android APK built with Flutter

Modular UI design

Real-time device control

BLoC pattern for state management

Firebase Realtime Database integration

Local storage using Hive

🔌 ESP8266 Hardware Control

7 relay outputs for appliances

2 servo motors (Door & Window automation)

Gas sensor monitoring

EEPROM-based WiFi credential storage

🌐 Offline Mode

ESP8266 creates its own WiFi Access Point

Web-based control panel

Relay & servo control via browser

WiFi configuration page

📂 Project Structure
📁 Flutter Application
lib/
 ├── main.dart
 ├── app.dart
 ├── bloc/
 │   └── settings/
 ├── constants/
 ├── hive/
 ├── routes/
 ├── theme/
 └── ui/
     ├── gas/
     ├── home/
     ├── relays/
     ├── servo/
     ├── splash/
     └── widgets/

📁 ESP8266 Firmware
esp8266/
 └── esp8266.ino

📁 Assets
assets/
 └── image/
     └── app_icon.png

🧪 Technologies Used
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

📦 Flutter Dependencies
Dependencies
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

⚙ ESP8266 Logic Overview
🔸 Online Mode

Connects to saved WiFi

Syncs relay & servo states from Firebase

Sends gas sensor data to Firebase

🔸 Offline Mode

Automatically switches to AP mode if WiFi fails

Hosts web server at 192.168.4.1

Supports:

Relay control

Servo angle control

WiFi setup

🏗 Build Android APK
flutter clean
flutter pub get
flutter build apk --release


📦 Output:

build/app/outputs/flutter-apk/app-release.apk

🔌 Upload ESP8266 Code

Open esp8266.ino in Arduino IDE

Select NodeMCU 1.0 (ESP-12E Module)

Select correct COM port

Upload code

🚀 Future Improvements

User authentication

Push notifications

Energy consumption monitoring

Voice control

OTA firmware updates

👨‍💻 Author

Muhammad Shoaib
BSCS Student
GitHub: MuhammadShoaib1930

📜 License

This project is for educational purposes only.
