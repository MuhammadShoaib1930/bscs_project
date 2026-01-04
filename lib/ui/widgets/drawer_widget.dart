import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_event.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
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
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24)),
              ),

              // Dark Mode Toggle
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: state.isDarkMode,
                onChanged: (_) => settingsBloc.add(ToggleDarkModeEvent()),
              ),

              // Font Size Dropdown
              ListTile(
                title: const Text('Font Size'),
                trailing: DropdownButton<double>(
                  value: state.fontSize,
                  items: [14, 16, 18, 20, 22]
                      .map(
                        (size) =>
                            DropdownMenuItem(value: size.toDouble(), child: Text(size.toString())),
                      )
                      .toList(),
                  onChanged: (size) {
                    if (size != null) {
                      settingsBloc.add(ChangeFontSizeEvent(size));
                    }
                  },
                ),
              ),

              // Font Family Dropdown
              ListTile(
                title: const Text('Font Family'),
                trailing: DropdownButton<String>(
                  value: state.fontFamily,
                  items: [
                    'Roboto',
                    'Open Sans',
                    'Lato',
                    'Montserrat',
                  ].map((font) => DropdownMenuItem(value: font, child: Text(font))).toList(),
                  onChanged: (font) {
                    if (font != null) {
                      settingsBloc.add(ChangeFontFamilyEvent(font));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
