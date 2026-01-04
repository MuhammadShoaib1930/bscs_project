import 'dart:convert';
import 'package:http/http.dart' as http;

class ESPOfflineService {
  static const String baseUrl = "http://192.168.4.1"; // ESP AP IP

  static Future<Map<String, dynamic>> getDeviceState() async {
    final res = await http.get(Uri.parse("$baseUrl/"));
    // Parse your HTML or expose a JSON endpoint on ESP for easier parsing
    // For simplicity, return dummy
    return {
      "relays": [false, false, false, false, false, false, false],
      "door": 0,
      "window": 0,
      "gas": 0,
    };
  }

  static Future<void> toggleRelay(int index) async {
    await http.get(Uri.parse("$baseUrl/r${index + 1}"));
  }

  static Future<void> setDoor(int angle) async {
    await http.get(Uri.parse("$baseUrl/door?a=$angle"));
  }

  static Future<void> setWindow(int angle) async {
    await http.get(Uri.parse("$baseUrl/window?a=$angle"));
  }
}
