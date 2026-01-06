import 'dart:async';
import 'dart:math';
import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _wifiController;
  late AnimationController _relayController;
  late AnimationController _gasController;
  late AnimationController _iconController;
  late AnimationController _textController;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, AppRoutes.home);
    });

    _wifiController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _relayController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _gasController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _iconController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _textController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _wifiController.dispose();
    _relayController.dispose();
    _gasController.dispose();
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _wifiController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // ignore: deprecated_member_use
                      Colors.blue.shade800.withOpacity(0.9),
                      Colors.deepPurple.shade700,
                      Colors.black87,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5 + 0.5 * _wifiController.value, 1.0],
                  ),
                ),
              );
            },
          ),

          Positioned(
            top: 100,
            left: 30,
            child: AnimatedBuilder(
              animation: _wifiController,
              builder: (_, child) {
                double scale = 0.8 + Curves.easeInOut.transform(_wifiController.value) * 0.4;
                return Transform.scale(
                  scale: scale,
                  child: Icon(
                    Icons.wifi,
                    color: Colors.greenAccent.shade400,
                    size: 50,
                    shadows: const [Shadow(color: Colors.greenAccent, blurRadius: 12)],
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: 220,
            right: 30,
            child: AnimatedBuilder(
              animation: _relayController,
              builder: (_, child) {
                Color color = _relayController.value > 0.5
                    ? Colors.redAccent
                    : Colors.grey.shade600;
                return Row(
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: const EdgeInsets.all(5),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        // ignore: deprecated_member_use
                        boxShadow: [BoxShadow(color: color.withOpacity(0.6), blurRadius: 6)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 180,
            left: 40,
            child: AnimatedBuilder(
              animation: _gasController,
              builder: (_, child) {
                double size = 30 + Curves.easeInOut.transform(_gasController.value) * 20;
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.orangeAccent.withOpacity(0.5),
                    boxShadow: [
                      // ignore: deprecated_member_use
                      BoxShadow(color: Colors.orangeAccent.withOpacity(0.6), blurRadius: 12),
                    ],
                  ),
                );
              },
            ),
          ),

          Center(
            child: AnimatedBuilder(
              animation: _iconController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: _iconController.value * 2 * pi,
                  child:  Icon(
                    ((_iconController.value*2).toInt() % 2 == 0)?Icons.wb_sunny_sharp:Icons.sunny,
                    size: 90,
                    color: ((_iconController.value*2).toInt() % 2 == 0)?const Color.fromARGB(255, 229, 235, 145):Colors.yellow,
                    shadows: [Shadow(color: const Color.fromARGB(225, 250, 80, 80), blurRadius: 300)],
                  ),
                );
              },
            ),
          ),

          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (_, child) {
                double offset = 10 * sin(_textController.value * 2 * pi);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -offset),
                      child: Text(
                        AppConstants.splashPageSubtitle,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.white30, blurRadius: 6)],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Opacity(
                      opacity: 0.5 + 0.5 * _textController.value,
                      child: Text(
                        AppConstants.splashPageDescription,
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
