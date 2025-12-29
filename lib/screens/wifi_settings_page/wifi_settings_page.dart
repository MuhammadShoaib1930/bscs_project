import 'package:flutter/material.dart';

class WifiSettingsPage extends StatefulWidget {
  const WifiSettingsPage({super.key});

  @override
  State<WifiSettingsPage> createState() => _WifiSettingsPageState();
}

class _WifiSettingsPageState extends State<WifiSettingsPage> {
  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isConnected = false;
  String connectedSsid = "--";

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      // later: fetch real ESP8266 WiFi status
    });
  }

  void _connectWifi() {
    // later: send SSID & Password to ESP8266
    setState(() {
      connectedSsid = ssidController.text;
      isConnected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 22),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.teal, Colors.blue]),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Column(
              children: const [
                Icon(Icons.wifi, color: Colors.white, size: 40),
                SizedBox(height: 6),
                Text(
                  "WiFi Settings",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text("ESP8266 Connection", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          /// BODY
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      /// CONNECTION STATUS
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: Icon(
                            isConnected ? Icons.wifi : Icons.wifi_off,
                            size: 36,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            isConnected ? "Connected" : "Not Connected",
                            style: const TextStyle(fontSize: 22),
                          ),
                          subtitle: Text(
                            "SSID: $connectedSsid",
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: Icon(
                            isConnected ? Icons.check_circle : Icons.error,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// SSID INPUT
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: TextField(
                            controller: ssidController,
                            decoration: const InputDecoration(
                              labelText: "WiFi SSID",
                              prefixIcon: Icon(Icons.router),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// PASSWORD INPUT
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "WiFi Password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CONNECT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.wifi_tethering),
                          label: Text(
                            isConnected ? "Reconnect WiFi" : "Connect WiFi",
                            style: const TextStyle(fontSize: 20),
                          ),
                          onPressed: _connectWifi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
