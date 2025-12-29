import 'package:bscs_project/screens/relays_page/bloc/relays_bloc.dart';
import 'package:bscs_project/screens/widgets/show_relay_settings_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RelaysPage extends StatefulWidget {
  const RelaysPage({super.key});

  @override
  State<RelaysPage> createState() => _RelaysPageState();
}

class _RelaysPageState extends State<RelaysPage> {
  @override
  void initState() {
    _getDataFromFirebase();
    super.initState();
  }

  Future<void> _getDataFromFirebase() async {
    context.read<RelaysBloc>().add(GetDataFromFirebase());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RelaysBloc, RelaysState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.blue, Colors.indigo]),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: const [
                    Icon(Icons.electrical_services, color: Colors.white, size: 40),
                    SizedBox(height: 6),
                    Text(
                      "Relay Settings",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    Text("Pull down to refresh", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _getDataFromFirebase,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            /// RELAY 1
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: Icon(
                                  state.isOn1 ? Icons.power : Icons.power_off,
                                  color: state.isOn1 ? Colors.green : Colors.red,
                                  size: 34,
                                ),
                                title: const Text("Relay 1", style: TextStyle(fontSize: 26)),
                                subtitle: Text(
                                  state.isOn1 ? "ON" : "OFF",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: state.isOn1 ? Colors.green : Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  context.read<RelaysBloc>().add(
                                    OnChangeRelayStatus(isTrue: state.isOn1, index: 1),
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    showRelaySettingsPopup(
                                      context,
                                      index: 1,
                                      initialPower: state.power1,
                                      initialTarget: state.target1,
                                      currentKwh: state.currentKwh1,
                                      startTime: state.startTime1,
                                      endTime: state.endTime1,
                                    );
                                  },
                                ),
                              ),
                            ),
      
                            const SizedBox(height: 12),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: Icon(
                                  state.isOn2 ? Icons.power : Icons.power_off,
                                  color: state.isOn2 ? Colors.green : Colors.red,
                                  size: 34,
                                ),
                                title: const Text("Relay 2", style: TextStyle(fontSize: 26)),
                                subtitle: Text(
                                  state.isOn2 ? "ON" : "OFF",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: state.isOn2 ? Colors.green : Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  context.read<RelaysBloc>().add(
                                    OnChangeRelayStatus(isTrue: state.isOn2, index: 2),
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    showRelaySettingsPopup(
                                      context,
                                      index: 2,
                                      initialPower: state.power2,
                                      initialTarget: state.target2,
                                      currentKwh: state.currentKwh2,
                                      startTime: state.startTime2,
                                      endTime: state.endTime2,
                                    );
                                  },
                                ),
                              ),
                            ),
      
                            const SizedBox(height: 12),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: Icon(
                                  state.isOn3 ? Icons.power : Icons.power_off,
                                  color: state.isOn3 ? Colors.green : Colors.red,
                                  size: 34,
                                ),
                                title: const Text("Relay 3", style: TextStyle(fontSize: 26)),
                                subtitle: Text(
                                  state.isOn3 ? "ON" : "OFF",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: state.isOn3 ? Colors.green : Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  context.read<RelaysBloc>().add(
                                    OnChangeRelayStatus(isTrue: state.isOn3, index: 3),
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    showRelaySettingsPopup(
                                      context,
                                      index: 3,
                                      initialPower: state.power3,
                                      initialTarget: state.target3,
                                      currentKwh: state.currentKwh3,
                                      startTime: state.startTime3,
                                      endTime: state.endTime3,
                                    );
                                  },
                                ),
                              ),
                            ),
      
                            const SizedBox(height: 12),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: Icon(
                                  state.isOn4 ? Icons.power : Icons.power_off,
                                  color: state.isOn4 ? Colors.green : Colors.red,
                                  size: 34,
                                ),
                                title: const Text("Relay 4", style: TextStyle(fontSize: 26)),
                                subtitle: Text(
                                  state.isOn4 ? "ON" : "OFF",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: state.isOn4 ? Colors.green : Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  context.read<RelaysBloc>().add(
                                    OnChangeRelayStatus(isTrue: state.isOn4, index: 4),
                                  );
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    showRelaySettingsPopup(
                                      context,
                                      index: 4,
                                      initialPower: state.power4,
                                      initialTarget: state.target4,
                                      currentKwh: state.currentKwh4,
                                      startTime: state.startTime4,
                                      endTime: state.endTime4,
                                    );
                                  },
                                ),
                              ),
                            ),
      
                            // const SizedBox(height: 12),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(builder: (context) => SplashPage()),
                            //     );
                            //   },
                            //   child: Text("test splash screen"),
                            // ),
                          ],
                        ),
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
