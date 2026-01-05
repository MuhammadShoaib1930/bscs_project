import 'dart:math';

import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/ui/servo/bloc/servo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServoPage extends StatefulWidget {
  const ServoPage({super.key});

  @override
  State<ServoPage> createState() => _ServoPageState();
}

class _ServoPageState extends State<ServoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final isDark = settingsState.settingsModel.isDarkMode;
        final font = settingsState.settingsModel.fontFamily;
        final fontSize = settingsState.settingsModel.fontSize;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppConstants.servoPageTitle,
              style: TextStyle(
                fontFamily: font,
                fontSize: fontSize + 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.deepPurple.shade700, Colors.deepPurple.shade900]
                      : [Colors.purpleAccent, Colors.deepPurpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            elevation: 4,
          ),
          body: BlocBuilder<ServoBloc, ServoState>(
            builder: (context, servoState) {
              if (servoState is ServoLoadedState) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: isDark ? Colors.grey[850] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            AppConstants.servoPageSubTitle,
                            style: TextStyle(
                              fontFamily: font,
                              fontSize: fontSize + 2,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildLogicServo(
                        title: 'Door Angle',
                        angle: servoState.doorAngle,
                        font: font,
                        fontSize: fontSize,
                        baseColor: Colors.blueAccent,
                        onChanged: (val) {
                          context.read<ServoBloc>().add(
                            DoorAngleChangeEvent(doorAngle: val.toInt()),
                          );
                        },
                        icon: Icons.door_front_door,
                      ),
                      const SizedBox(height: 40),

                      _buildLogicServo(
                        title: 'Window Angle',
                        angle: servoState.windowAngle,
                        font: font,
                        fontSize: fontSize,
                        baseColor: Colors.orangeAccent,
                        onChanged: (val) {
                          context.read<ServoBloc>().add(
                            WindowAngleChangeEvent(windowAngle: val.toInt()),
                          );
                        },
                        icon: Icons.window,
                      ),
                    ],
                  ),
                );
              } else {
                context.read<ServoBloc>().add(GetFromFirebaseEvent());
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildLogicServo({
    required String title,
    required int angle,
    required String font,
    required double fontSize,
    required Color baseColor,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    double rotationY = (angle / 180) * (pi / 2);

    return Column(
      children: [
        Text(
          '$title: $angle°',
          style: TextStyle(fontFamily: font, fontSize: fontSize, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),

        Container(
          height: 140,
          width: 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [baseColor.withAlpha(180), baseColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(4, 4)),
            ],
          ),
          child: Center(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateY(rotationY), // rotate in 3D
              child: Icon(icon, size: 60, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 16),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: baseColor,
            inactiveTrackColor: baseColor.withAlpha(100),
            thumbColor: baseColor,
            overlayColor: baseColor.withAlpha(50),
            valueIndicatorColor: baseColor,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),
          child: Slider(
            value: angle.toDouble(),
            min: 0,
            max: 180,
            divisions: 18,
            label: angle.toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
