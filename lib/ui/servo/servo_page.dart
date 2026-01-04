import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServoPage extends StatefulWidget {
  const ServoPage({super.key});

  @override
  State<ServoPage> createState() => _ServoPageState();
}

class _ServoPageState extends State<ServoPage> {
  int doorAngle = 0;
  int windowAngle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servo Control'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Control Door & Window',
                  style: TextStyle(
                    fontSize: state.fontSize + 4,
                    fontFamily: state.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // --- Door Servo ---
                Text(
                  'Door Angle: $doorAngle°',
                  style: TextStyle(fontSize: state.fontSize, fontFamily: state.fontFamily),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(4, 4)),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.door_front_door, size: 48, color: Colors.white),
                  ),
                ),
                Slider(
                  value: doorAngle.toDouble(),
                  min: 0,
                  max: 180,
                  divisions: 18,
                  label: doorAngle.toString(),
                  activeColor: Colors.blueAccent,
                  onChanged: (val) => setState(() => doorAngle = val.toInt()),
                ),
                const SizedBox(height: 30),

                // --- Window Servo ---
                Text(
                  'Window Angle: $windowAngle°',
                  style: TextStyle(fontSize: state.fontSize, fontFamily: state.fontFamily),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(4, 4)),
                    ],
                  ),
                  child: const Center(child: Icon(Icons.window, size: 48, color: Colors.white)),
                ),
                Slider(
                  value: windowAngle.toDouble(),
                  min: 0,
                  max: 180,
                  divisions: 18,
                  label: windowAngle.toString(),
                  activeColor: Colors.orangeAccent,
                  onChanged: (val) => setState(() => windowAngle = val.toInt()),
                ),

                const SizedBox(height: 20),
                Text(
                  'Drag sliders to rotate Door & Window',
                  style: TextStyle(
                    fontSize: state.fontSize,
                    fontFamily: state.fontFamily,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
