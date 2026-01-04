import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';
import '../../bloc/settings/settings_event.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SettingsBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text('Dark Mode'),
                  value: state.isDarkMode,
                  onChanged: (_) => bloc.add(ToggleDarkModeEvent()),
                ),
                SizedBox(height: 20),
                Text('Font Size'),
                DropdownButton<double>(
                  value: state.fontSize,
                  items: [14, 16, 18, 20, 22]
                      .map(
                        (size) =>
                            DropdownMenuItem(value: size.toDouble(), child: Text(size.toString())),
                      )
                      .toList(),
                  onChanged: (size) {
                    if (size != null) bloc.add(ChangeFontSizeEvent(size));
                  },
                ),
                SizedBox(height: 20),
                Text('Font Family'),
                DropdownButton<String>(
                  value: state.fontFamily,
                  items: [
                    'Roboto',
                    'Open Sans',
                    'Lato',
                    'Montserrat',
                  ].map((font) => DropdownMenuItem(value: font, child: Text(font))).toList(),
                  onChanged: (font) {
                    if (font != null) bloc.add(ChangeFontFamilyEvent(font));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
