import 'package:flutter/material.dart';
import 'dart:math';

class GaugeWidget extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final double maxValue;

  const GaugeWidget({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 10),
        CustomPaint(
          size: const Size(150, 75),
          painter: GaugePainter(value, color, maxValue),
        ),
        const SizedBox(height: 10),
        Text('${value.toStringAsFixed(1)}', style: TextStyle(fontSize: 24, color: color)),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final double maxValue;

  GaugePainter(this.value, this.color, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;
    double angle = pi * (value / maxValue);  // Adjusted to ensure the range is from 0 to pi

    // Draw background arc
    canvas.drawArc(Rect.fromCircle(center: Offset(radius, radius), radius: radius), pi, pi, false, paint);

    // Draw progress arc
    canvas.drawArc(Rect.fromCircle(center: Offset(radius, radius), radius: radius), pi, angle, false, progressPaint);

    // Draw the dot at the end of the progress arc
    Offset dotPosition = Offset(radius + radius * cos(pi + angle), radius + radius * sin(pi + angle));
    canvas.drawCircle(dotPosition, 12.0, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
