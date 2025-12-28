import 'package:bscs_project/core/helper.dart';
import 'package:bscs_project/screens/relays_page/bloc/relays_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showRelaySettingsPopup(
  BuildContext parentContext, {
  required int index,
  required int initialPower,
  required double initialTarget,
  required double currentKwh,
  required String startTime,
  required String endTime,
}) async {
  final powerController = TextEditingController(text: initialPower.toString());
  final targetController = TextEditingController(text: initialTarget.toString());

  String start = startTime;
  String end = endTime;

  return showDialog(
    context: parentContext, // ✅ use parent context
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Relay Settings"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: powerController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Power (Watt)"),
                ),

                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Target (kWh)"),
                ),

                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Current (kWh)",
                    hintText: currentKwh.toStringAsFixed(3),
                  ),
                ),

                const SizedBox(height: 12),

                ListTile(
                  title: Text("Start Time: $start", style: const TextStyle(color: Colors.pink)),
                  trailing: const Icon(Icons.access_time, color: Colors.pink),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: Helper.parseSafeTime(start),
                    );
                    if (t != null) {
                      setState(() {
                        start =
                            "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),

                ListTile(
                  title: Text("End Time: $end", style: const TextStyle(color: Colors.pink)),
                  trailing: const Icon(Icons.access_time, color: Colors.pink),
                  onTap: () async {
                    final t = await showTimePicker(
                      context: context,
                      initialTime: Helper.parseSafeTime(end),
                    );
                    if (t != null) {
                      setState(() {
                        end =
                            "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              parentContext.read<RelaysBloc>().add(
                ChangeSettingRelays(
                  index: index,
                  initialPower: int.parse(powerController.text),
                  initialTarget: double.parse(targetController.text),
                  currentKwh: currentKwh,
                  startTime: start,
                  endTime: end,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}
