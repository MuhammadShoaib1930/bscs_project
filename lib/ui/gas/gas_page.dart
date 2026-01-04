import 'package:flutter/material.dart';
import 'dart:math';

class GasPage extends StatefulWidget {
  const GasPage({super.key});

  @override
  State<GasPage> createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> {
  int gasValue = 0;

  @override
  Widget build(BuildContext context) {
    // Example: Simulate gas reading change
    // In real app, replace with your Firebase or ESP data
    gasValue = (gasValue + 1) % 1024;

    // Determine color based on gas value
    Color gaugeColor;
    if (gasValue < 300) {
      gaugeColor = Colors.green;
    } else if (gasValue < 700) {
      gaugeColor = Colors.orange;
    } else {
      gaugeColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Sensor'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Gas Level', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),

            // Circular gauge
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade200),
                  ),

                  // Arc indicator
                  Transform.rotate(
                    angle: -pi / 2,
                    child: CustomPaint(
                      size: const Size(200, 200),
                      painter: _GaugePainter(gasValue.toDouble(), gaugeColor),
                    ),
                  ),

                  // Value display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$gasValue',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: gaugeColor,
                        ),
                      ),
                      const Text('PPM', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Green: Safe | Orange: Medium | Red: Danger',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the gauge arc
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
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(10), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
