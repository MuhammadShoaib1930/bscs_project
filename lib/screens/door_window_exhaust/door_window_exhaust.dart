import 'package:flutter/material.dart';

class DoorWindowExhaust extends StatefulWidget {
  const DoorWindowExhaust({super.key});

  @override
  State<DoorWindowExhaust> createState() => _DoorWindowExhaustState();
}

class _DoorWindowExhaustState extends State<DoorWindowExhaust> {
  double doorAngle = 0;
  double windowAngle = 0;
  double gasLevel = 20;
  double exhaustSpeed = 0; // corrected variable

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {}); // simulate refresh
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// HEADER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
          ),
          child: Column(
            children: const [
              Icon(Icons.sensor_door, color: Colors.white, size: 40),
              SizedBox(height: 6),
              Text(
                "Door • Window • Exhaust",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text("Pull down to refresh", style: TextStyle(color: Colors.white70)),
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
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    /// DOOR ANGLE
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: const Icon(Icons.door_front_door, size: 36),
                        title: const Text("Door Angle", style: TextStyle(fontSize: 22)),
                        subtitle: Slider(
                          value: doorAngle,
                          min: 0,
                          max: 180,
                          divisions: 180,
                          label: "${doorAngle.toInt()}°",
                          onChanged: (value) {
                            setState(() => doorAngle = value);
                          },
                        ),
                        trailing: Text(
                          "${doorAngle.toInt()}°",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// WINDOW ANGLE
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: const Icon(Icons.window, size: 36),
                        title: const Text("Window Angle", style: TextStyle(fontSize: 22)),
                        subtitle: Slider(
                          value: windowAngle,
                          min: 0,
                          max: 180,
                          divisions: 180,
                          label: "${windowAngle.toInt()}°",
                          onChanged: (value) {
                            setState(() => windowAngle = value);
                          },
                        ),
                        trailing: Text(
                          "${windowAngle.toInt()}°",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// GAS SENSOR
                    /// GAS SENSOR
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: Icon(
                          Icons.sensors,
                          color: gasLevel > 60 ? Colors.red : Colors.green,
                          size: 36,
                        ),
                        title: const Text("Gas Sensor", style: TextStyle(fontSize: 22)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: gasLevel / 100,
                              color: gasLevel > 60 ? Colors.red : Colors.green,
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              gasLevel > 60 ? "Risk" : "Normal",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: gasLevel > 60 ? Colors.red : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          "${gasLevel.toInt()}%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: gasLevel > 60 ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// EXHAUST FAN (ESC STYLE)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      child: ListTile(
                        leading: const Icon(Icons.air, size: 36, color: Colors.blueAccent),
                        title: const Text("Exhaust Fan Speed", style: TextStyle(fontSize: 22)),
                        subtitle: Slider(
                          value: exhaustSpeed,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: "${exhaustSpeed.toInt()}%",
                          onChanged: (value) {
                            setState(() {
                              exhaustSpeed = value;
                            });
                          },
                          activeColor: Colors.blue,
                          inactiveColor: Colors.blue.shade100,
                        ),
                        trailing: Text(
                          "${exhaustSpeed.toInt()}%",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}
