import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final db = FirebaseDatabase.instance.ref();

  static Future<bool> checkConnection() async {
    try {
      final snapshot = await db.child("ping").get();
      return snapshot.exists;
    } catch (_) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getDeviceState() async {
    final relaysSnap = await db.child("relay").get();
    final doorSnap = await db.child("servo/door").get();
    final windowSnap = await db.child("servo/window").get();
    final gasSnap = await db.child("sensor/gas").get();

    List<bool> relays = List.generate(7, (i) => relaysSnap.child("r${i + 1}").value == true);
    return {
      "relays": relays,
      "door": doorSnap.value ?? 0,
      "window": windowSnap.value ?? 0,
      "gas": gasSnap.value ?? 0,
    };
  }

  static Future<void> toggleRelay(int index) async {
    final snap = await db.child("relay/r${index + 1}").get();
    bool val = snap.value == true;
    await db.child("relay/r${index + 1}").set(!val);
  }

  static Future<void> setDoor(int angle) async {
    await db.child("servo/door").set(angle);
  }

  static Future<void> setWindow(int angle) async {
    await db.child("servo/window").set(angle);
  }
}
