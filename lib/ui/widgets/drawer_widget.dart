import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_event.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();

    return Drawer(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final font = state.settingsModel.fontFamily;
          final fontSize = state.settingsModel.fontSize;
          final isDark = state.settingsModel.isDarkMode;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.deepPurple.shade700, Colors.deepPurple.shade900]
                        : [Colors.purpleAccent, Colors.deepPurpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    AppConstants.appDrawer,
                    style: TextStyle(
                      fontFamily: font,
                      fontSize: fontSize + 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),

              SwitchListTile(
                title: Text(
                  state.settingsModel.isDarkMode? 'Dark':"Light",
                  style: TextStyle(fontFamily: font, fontSize: fontSize),
                ),
                value: state.settingsModel.isDarkMode,
                onChanged: (_) => settingsBloc.add(ToggleDarkModeEvent()),
                activeColor: Colors.deepPurple,
                secondary: state.settingsModel.isDarkMode? Icon(Icons.dark_mode):Icon(Icons.light_mode),
              ),

              const Divider(height: 1, thickness: 1),

              ListTile(
                title: Text(
                  'Font Size',
                  style: TextStyle(fontFamily: font, fontSize: fontSize),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                  child: DropdownButton<double>(
                    value: state.settingsModel.fontSize,
                    underline: const SizedBox(),
                    dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                    items: AppConstants.fontSize
                        .map(
                          (size) => DropdownMenuItem(
                            value: size.toDouble(),
                            child: Text(
                              size.toString(),
                              style: TextStyle(fontFamily: font, fontSize: fontSize),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (size) {
                      if (size != null) {
                        settingsBloc.add(ChangeFontSizeEvent(size));
                      }
                    },
                  ),
                ),
              ),

              const Divider(height: 1, thickness: 1),

              ListTile(
                title: Text(
                  'Font Family',
                  style: TextStyle(fontFamily: font, fontSize: fontSize),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  ),
                  child: DropdownButton<String>(
                    value: state.settingsModel.fontFamily,
                    underline: const SizedBox(),
                    dropdownColor: isDark ? Colors.grey.shade900 : Colors.white,
                    items: AppConstants.fontFamily
                        .map(
                          (fontName) => DropdownMenuItem(
                            value: fontName,
                            child: Text(
                              fontName,
                              style: TextStyle(fontFamily: fontName, fontSize: fontSize),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (fontName) {
                      if (fontName != null) {
                        settingsBloc.add(ChangeFontFamilyEvent(fontName));
                      }
                    },
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
