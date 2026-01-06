// ignore_for_file: deprecated_member_use

import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/routes/app_routes.dart';
import 'package:bscs_project/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final isDark = state.settingsModel.isDarkMode;
        final font = state.settingsModel.fontFamily;
        final fontSize = state.settingsModel.fontSize;

        return Scaffold(
          key: _scaffoldKey,
          drawer: const DrawerWidget(),
          appBar: AppBar(
            elevation: 4,
            centerTitle: true,
            title: Text(
              AppConstants.homePageTitle,
              style: TextStyle(
                fontSize: fontSize + 2,
                fontFamily: font,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.grey[850]!, Colors.grey[900]!]
                      : [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                  color: isDark ? Colors.grey[800] : Colors.white,
                  shadowColor: Colors.black45,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          AppConstants.homePageSubTitle,
                          style: TextStyle(
                            fontSize: fontSize + 4,
                            fontFamily: font,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.homePageDescription,
                          style: TextStyle(fontSize: fontSize, fontFamily: font),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 1,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildFeatureButton(
                      label: 'Relays',
                      icon: Icons.power,
                      font: font,
                      fontSize: fontSize,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.relays),
                    ),
                    _buildFeatureButton(
                      label: 'Servos',
                      icon: Icons.settings,
                      font: font,
                      fontSize: fontSize,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.servo),
                    ),
                    _buildFeatureButton(
                      label: 'Gas',
                      icon: Icons.air,
                      font: font,
                      fontSize: fontSize,
                      isDark: isDark,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.gas),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureButton({
    required String label,
    required IconData icon,
    required String font,
    required double fontSize,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: isDark ? Colors.blueGrey : Colors.blueAccent.withOpacity(0.2),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.blueGrey.shade700, Colors.blueGrey.shade900]
                : [Colors.lightBlueAccent, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.grey.shade400,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: fontSize + 4),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: font,
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
