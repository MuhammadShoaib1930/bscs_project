import 'package:bscs_project/bloc/settings/settings_bloc.dart';
import 'package:bscs_project/bloc/settings/settings_state.dart';
import 'package:bscs_project/constants/app_constants.dart';
import 'package:bscs_project/ui/gas/bloc/gas_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

class GasPage extends StatefulWidget {
  const GasPage({super.key});

  @override
  State<GasPage> createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final font = settingsState.settingsModel.fontFamily;
        final fontSize = settingsState.settingsModel.fontSize;
        final isDark = settingsState.settingsModel.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppConstants.gasPageTitle,
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
          body: BlocBuilder<GasBloc, GasState>(
            builder: (context, gasState) {
              if (gasState is GasLoadedState) {
                Color gaugeColor;
                String warningText;
                if ((gasState.gasValue + 1) % 1024 < 300) {
                  gaugeColor = Colors.green;
                  warningText = AppConstants.warning1Text;
                } else if ((gasState.gasValue + 1) % 1024 < 700) {
                  gaugeColor = Colors.orange;
                  warningText = AppConstants.warning2Text;
                } else if ((gasState.gasValue + 1) % 1024 < 900) {
                  gaugeColor = Colors.redAccent;
                  warningText = AppConstants.warning3Text;
                } else {
                  gaugeColor = Colors.red.shade900;
                  warningText = AppConstants.warning4Text;
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        warningText,
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: fontSize + 4,
                          fontWeight: FontWeight.bold,
                          color: gaugeColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      AnimatedGauge(
                        value: gasState.gasValue.toDouble(),
                        color: gaugeColor,
                        font: font,
                        fontSize: fontSize,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'PPM: ${gasState.gasValue}',
                        style: TextStyle(
                          fontFamily: font,
                          fontSize: fontSize,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}

class AnimatedGauge extends StatefulWidget {
  final double value;
  final Color color;
  final String font;
  final double fontSize;

  const AnimatedGauge({
    super.key,
    required this.value,
    required this.color,
    required this.font,
    required this.fontSize,
  });

  @override
  State<AnimatedGauge> createState() => _AnimatedGaugeState();
}

class _AnimatedGaugeState extends State<AnimatedGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double oldValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(
      begin: oldValue,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<double>(
      begin: oldWidget.value,
      end: widget.value,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade200,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(4, 4)),
                  ],
                ),
              ),
              Transform.rotate(
                angle: -pi / 2,
                child: CustomPaint(
                  size: const Size(220, 220),
                  painter: _GaugePainter(_animation.value, widget.color),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_animation.value.toInt()}',
                    style: TextStyle(
                      fontFamily: widget.font,
                      fontSize: widget.fontSize + 6,
                      fontWeight: FontWeight.bold,
                      color: widget.color,
                    ),
                  ),
                  Text(
                    'PPM',
                    style: TextStyle(
                      fontFamily: widget.font,
                      fontSize: widget.fontSize,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = 0.0;
    final sweepAngle = 2 * pi * (value / 1024);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(10), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
