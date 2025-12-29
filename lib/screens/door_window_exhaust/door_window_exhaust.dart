import 'package:bscs_project/screens/door_window_exhaust/bloc/door_window_exhaust_gas_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoorWindowExhaust extends StatefulWidget {
  const DoorWindowExhaust({super.key});

  @override
  State<DoorWindowExhaust> createState() => _DoorWindowExhaustState();
}

class _DoorWindowExhaustState extends State<DoorWindowExhaust> {
  @override
  void initState() {
    _getDataFromFirebase();
    super.initState();
  }

  Future<void> _getDataFromFirebase() async {
    context.read<DoorWindowExhaustGasBloc>().add(GetValuesFromFirebase());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<DoorWindowExhaustGasBloc, DoorWindowExhaustGasState>(
        builder: (context, state) {
          return Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.sensor_door, color: Colors.white, size: 40),
                    SizedBox(height: 6),
                    Text(
                      "Door • Window • Exhaust",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text("Pull down to refresh", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _getDataFromFirebase,
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
                                value: state.door.toDouble(),
                                min: 0,
                                max: 180,
                                divisions: 180,
                                label: "${state.door}° ",
                                onChanged: (value) {
                                  context.read<DoorWindowExhaustGasBloc>().add(
                                    ChangeDoorAngle(doorAngle: value.toInt()),
                                  );
                                },
                              ),
                              trailing: Text(
                                "${state.door}°",
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
                                value: state.window.toDouble(),
                                min: 0,
                                max: 180,
                                divisions: 180,
                                label: "${state.window}°",
                                onChanged: (value) {
                                  context.read<DoorWindowExhaustGasBloc>().add(
                                    ChangeWindowAngle(windowAngle: value.toInt()),
                                  );
                                },
                              ),
                              trailing: Text(
                                "${state.window}°",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              title: const Text(
                                "Exhaust Fan Speed",
                                style: TextStyle(fontSize: 22),
                              ),
                              subtitle: Slider(
                                value: state.exhaust.toDouble(),
                                min: 0,
                                max: 100,
                                divisions: 100,
                                label: "${state.exhaust}%",
                                onChanged: (value) {
                                  context.read<DoorWindowExhaustGasBloc>().add(
                                    ChangeExhaustSpeed(exhaustSpeed: value.toInt()),
                                  );
                                },
                                activeColor: Colors.blue,
                                inactiveColor: Colors.blue.shade100,
                              ),
                              trailing: Text(
                                "${state.exhaust}%",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          /// GAS SENSOR
                          GestureDetector(
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.sensors,
                                  color: state.gasValue > state.gasThreshold
                                      ? Colors.red
                                      : Colors.green,
                                  size: 36,
                                ),
                                title: const Text("Gas Sensor", style: TextStyle(fontSize: 22)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LinearProgressIndicator(
                                      value: state.gasValue / 100,
                                      color: state.gasValue > state.gasThreshold
                                          ? Colors.red
                                          : Colors.green,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      state.gasValue > state.gasThreshold ? "Risk" : "Normal",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: state.gasValue > state.gasThreshold
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  "${state.gasValue.toInt()}%",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: state.gasValue > state.gasThreshold
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            onLongPress: () {
                              context.read<DoorWindowExhaustGasBloc>().add(
                                IsThresholdEnable(isThresholdEnable: !state.isThresholdEnable),
                              );
                            },
                          ),

                          const SizedBox(height: 20),

                          /// GAS THRESHOLD CARD
                          (state.isThresholdEnable)
                              ? Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.sensors,
                                      size: 36,
                                      color: Colors.blueAccent,
                                    ),
                                    title: const Text(
                                      "Gas Threshold",
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    subtitle: Slider(
                                      value: state.gasThreshold.toDouble(),
                                      min: 0,
                                      max: 100,
                                      divisions: 100,
                                      label: "${state.gasThreshold}%",
                                      onChanged: (value) {
                                        context.read<DoorWindowExhaustGasBloc>().add(
                                          ChangeGasThreshold(gasThreshold: value.toInt()),
                                        );
                                      },
                                      activeColor: Colors.blueAccent,
                                      inactiveColor: Colors.blueAccent.shade100,
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "${state.gasThreshold}%",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
