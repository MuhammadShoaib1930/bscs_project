// import 'package:bscs_project/screens/door_window_exhaust/door_window_exhaust.dart';
// import 'package:bscs_project/screens/relays_page/bloc/relays_bloc.dart';
// import 'package:bscs_project/screens/relays_page/relays_page.dart';
// import 'package:bscs_project/screens/bottom_slider_pages/bloc/bottom_slider_page_bloc.dart';
// import 'package:bscs_project/screens/wifi_settings_page/wifi_settings_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class BottomSliderPages extends StatefulWidget {
//   const BottomSliderPages({super.key});

//   @override
//   State<BottomSliderPages> createState() => _BottomSliderPagesState();
// }

// class _BottomSliderPagesState extends State<BottomSliderPages> {
//   final PageController _pageController = PageController();

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<BottomSliderPageBloc, BottomSliderPageState>(
//       builder: (context, state) {
//         return Scaffold(
//           body: PageView(
//             controller: _pageController,
//             onPageChanged: (index) {
//               context.read<BottomSliderPageBloc>().add(ChangePage(pageIndex: index));
//             },
//             children: [
//               BlocProvider(create: (context) => RelaysBloc(), child: RelaysPage()),
//               DoorWindowExhaust(),
//               WifiSettingsPage()
//             ],
//           ),
//           bottomNavigationBar: Container(
//             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//             color: Colors.grey[200],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(3, (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     _pageController.animateToPage(
//                       index,
//                       duration: Duration(milliseconds: 300),
//                       curve: Curves.easeInOut,
//                     );
//                   },
//                   child: Container(
//                     width: 60,
//                     height: 10,
//                     decoration: BoxDecoration(
//                       color: state.pageIndex == index ? Colors.blue : Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:bscs_project/screens/door_window_exhaust/bloc/door_window_exhaust_gas_bloc.dart';
import 'package:bscs_project/screens/door_window_exhaust/door_window_exhaust.dart';
import 'package:bscs_project/screens/relays_page/bloc/relays_bloc.dart';
import 'package:bscs_project/screens/relays_page/relays_page.dart';
import 'package:bscs_project/screens/bottom_slider_pages/bloc/bottom_slider_page_bloc.dart';
import 'package:bscs_project/screens/wifi_settings_page/bloc/wifi_settings_bloc.dart';
import 'package:bscs_project/screens/wifi_settings_page/wifi_settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomSliderPages extends StatefulWidget {
  const BottomSliderPages({super.key});

  @override
  State<BottomSliderPages> createState() => _BottomSliderPagesState();
}

class _BottomSliderPagesState extends State<BottomSliderPages> {
  final PageController _pageController = PageController();

  final List<IconData> _icons = [Icons.power_outlined, Icons.sensor_door, Icons.wifi];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomSliderPageBloc, BottomSliderPageState>(
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<BottomSliderPageBloc>().add(ChangePage(pageIndex: index));
            },
            children: [
              BlocProvider(create: (context) => RelaysBloc(), child: RelaysPage()),
              BlocProvider(
                create: (context) => DoorWindowExhaustGasBloc(),
                child: DoorWindowExhaust(),
              ),
              BlocProvider(create: (context) => WifiSettingsBloc(), child: WifiSettingsPage()),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, -4)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_icons.length, (index) {
                bool isSelected = state.pageIndex == index;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white24,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      _icons[index],
                      color: isSelected ? Colors.indigo : Colors.white,
                      size: isSelected ? 32 : 28,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
