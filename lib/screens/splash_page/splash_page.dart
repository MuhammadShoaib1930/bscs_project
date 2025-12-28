import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;
  late AnimationController _backgroundController;
  late Animation<Color?> _backgroundAnimation;

  final List<_Particle> _particles = List.generate(30, (_) => _Particle());

  @override
  void initState() {
    super.initState();

    // Logo bounce & glow
    _logoController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _logoAnimation = Tween<double>(
      begin: 0.7,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoController.repeat(reverse: true);

    // Background color gradient
    _backgroundController = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat(reverse: true);
    _backgroundAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.blueAccent,
    ).animate(_backgroundController);

    // Navigate to main page after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/bottomSliderPages');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_backgroundAnimation.value!, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // Floating particles
              ..._particles.map(
                (p) => Positioned(
                  left: p.x * MediaQuery.of(context).size.width,
                  top: p.y * MediaQuery.of(context).size.height,
                  child: Icon(p.icon, size: p.size, color: p.color.withOpacity(0.7)),
                ),
              ),

              // Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo with glow
                  ScaleTransition(
                    scale: _logoAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 24,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.widgets_rounded, color: Colors.white, size: 120),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // App Name slide & fade
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: const Text(
                            "Universal Controller",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Subtitle
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: const Text(
                            "Manage Your Devices Anywhere",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Animated Loading Dots (wave effect)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Transform.translate(
                            offset: Offset(0, sin((value + index * 0.3) * pi * 2) * 10),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Particle {
  double x = Random().nextDouble();
  double y = Random().nextDouble();
  double size = 8 + Random().nextDouble() * 12;
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  IconData icon = Icons.circle;
}
