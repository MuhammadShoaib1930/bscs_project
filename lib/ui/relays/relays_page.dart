import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/ui/relays/bloc/relays_bloc.dart';
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
    super.initState();
    context.read<RelaysBloc>().add(RelayGetStateEvent());
  }

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
              AppConstants.relayPageTitle,
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<RelaysBloc, RelaysState>(
              builder: (context, relaysState) {
                if (relaysState is RelaysLoaded) {
                  final relay1 = relaysState.relay1;
                  final relay2 = relaysState.relay2;
                  final relay3 = relaysState.relay3;
                  final relay4 = relaysState.relay4;
                  final relay5 = relaysState.relay5;
                  final relay6 = relaysState.relay6;
                  final relay7 = relaysState.relay7;

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: isDark ? Colors.grey[800] : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              AppConstants.relayPageDescription,
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: fontSize,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 1, relayState: !relay1),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay1
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 1 ${relay1 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 2, relayState: !relay2),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay2
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 2 ${relay2 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 3, relayState: !relay3),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay3
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 3 ${relay3 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 4, relayState: !relay4),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay4
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 4 ${relay4 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 5, relayState: !relay5),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay5
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 5 ${relay5 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 6, relayState: !relay6),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay6
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 6 ${relay6 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => context.read<RelaysBloc>().add(
                                  RelayToggleEvent(relayIndex: 7, relayState: !relay7),
                                ),
                                borderRadius: BorderRadius.circular(16),
                                splashColor: isDark
                                    ? Colors.deepPurple.shade400
                                    : Colors.purpleAccent.withAlpha((0.2 * 255).toInt()),
                                child: Ink(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: relay7
                                          ? [Colors.greenAccent.shade400, Colors.green.shade700]
                                          : isDark
                                          ? [Colors.grey.shade700, Colors.grey.shade900]
                                          : [Colors.grey.shade300, Colors.grey.shade400],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Relay 7 ${relay7 ? "ON" : "OFF"}",
                                      style: TextStyle(
                                        fontFamily: font,
                                        fontSize: fontSize + 1,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                } else {
                  context.read<RelaysBloc>().add(RelayGetStateEvent());
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
