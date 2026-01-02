import 'package:bscs_project/screens/relays_page/bloc/relays_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Future<Object?>> showRelaySettingsPopup(
  BuildContext parentContext, {
  required int index,
  required int initialPower,
  required double initialTarget,
  required double currentKwh,
}) async {
  final powerController = TextEditingController(text: initialPower.toString());
  final targetController = TextEditingController(text: initialTarget.toString());

  return showGeneralDialog(
    context: parentContext,
    barrierDismissible: false,
    barrierLabel: "RelaySettings",
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return const SizedBox();
    },
    transitionBuilder: (_, animation, __, ___) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: animation,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(18),
            titlePadding: EdgeInsets.zero,
            title: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.blue]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.power, color: Colors.white, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    "Relay ${index + 1} Settings",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      /// POWER INPUT
                      TextField(
                        controller: powerController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Power Consumption",
                          suffixText: "W",
                          prefixIcon: Icon(Icons.flash_on),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// TARGET INPUT
                      TextField(
                        controller: targetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Target Energy",
                          suffixText: "kWh",
                          prefixIcon: Icon(Icons.bolt),
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// CURRENT INFO CARD
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bar_chart, color: Colors.blue),
                            const SizedBox(width: 10),
                            Text(
                              "Current Usage: ${currentKwh.toStringAsFixed(3)} kWh",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(parentContext),
                child: const Text("Cancel"),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  parentContext.read<RelaysBloc>().add(
                    ChangeSettingRelays(
                      index: index,
                      initialPower: int.tryParse(powerController.text) ?? initialPower,
                      initialTarget: double.tryParse(targetController.text) ?? initialTarget,
                      currentKwh: currentKwh,
                    ),
                  );
                  Navigator.pop(parentContext);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
