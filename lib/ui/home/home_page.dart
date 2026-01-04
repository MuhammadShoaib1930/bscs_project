import 'package:bscs_project/routes/app_routes.dart';
import 'package:bscs_project/ui/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        // Wrap Scaffold in a Theme to apply dynamic font and brightness
        return Theme(
          data: ThemeData(
            brightness: state.isDarkMode ? Brightness.dark : Brightness.light,
            textTheme: Theme.of(context).textTheme.apply(
              fontFamily: state.fontFamily,
              bodyColor: state.isDarkMode ? Colors.white : Colors.black,
              displayColor: state.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Home Page',
                style: TextStyle(
                  fontSize: state.fontSize + 2, // Slightly larger for title
                  fontFamily: state.fontFamily,
                ),
              ),
            ),
            drawer: const DrawerWidget(),
            body: Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: (){Navigator.pushNamed(context, AppRoutes.relays);},
                    child: Text(
                      "Relays",
                      style: TextStyle(fontSize: state.fontSize, fontFamily: state.fontFamily),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.servo);
                    },
                    child: Text(
                      "Servos",
                      style: TextStyle(fontSize: state.fontSize, fontFamily: state.fontFamily),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
Navigator.pushNamed(context, AppRoutes.gas);

                    },
                    child: Text(
                      "Gas",
                      style: TextStyle(fontSize: state.fontSize, fontFamily: state.fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
