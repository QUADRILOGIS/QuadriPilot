import 'dart:math';
import 'package:flutter/material.dart';

class ChartData {
  final String label;

  /// A progress value from 0.0 to 1.0.
  final double value;
  final Color color;

  const ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}

class RadialConcentricChart extends StatelessWidget {
  final List<ChartData> data;
  final Size size; // Configurable overall chart size

  const RadialConcentricChart({
    super.key,
    required this.data,
    this.size = const Size(300, 300), // Default size
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RadialConcentricChartPainter(data: data),
      size: size,
    );
  }
}

class RadialConcentricChartPainter extends CustomPainter {
  final List<ChartData> data;

  RadialConcentricChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    // Position the center at the bottom of the zone.
    final center = Offset(size.width / 2, size.height / 1.5);
    // Ensure the circle fits within the width and height.
    final maxRadius = min(size.width / 2, size.height * 1.5);

    // Compute arc properties relative to the overall size.
    final double strokeWidth =
        maxRadius * 0.13; // e.g., ~20 for a 300x300 chart
    final double spacing = strokeWidth * 0.5; // e.g., ~10 for a 300x300 chart
    final double textPadding =
        strokeWidth * 0.25; // e.g., ~5 for a 300x300 chart
    final double extraVerticalOffset =
        strokeWidth * 1.0; // e.g., ~20 for a 300x300 chart
    final double textFontSize =
        strokeWidth * 0.5; // e.g., ~10 for a 300x300 chart

    // Calculate the total value among your data for normalization.
    final double totalValue = data.fold(0.0, (sum, chart) => sum + chart.value);

    // Start drawing from the outermost ring.
    double currentRadius = maxRadius - strokeWidth / 2;

    for (var chart in data) {
      // Normalize the value for arc drawing.
      final normalizedValue = chart.value / totalValue;

      // Compute the sweep of the progress arc based on normalized value.
      final sweepAngle = normalizedValue * 2 * pi;
      // Center the arc around the top (-pi/2)
      final startAngle = -pi / 2 - (sweepAngle / 2);
      final endAngle = startAngle + sweepAngle;

      // Draw the progress arc.
      final progressPaint = Paint()
        ..color = chart.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // Compute endpoints for text placement.
      final startPoint = Offset(
        center.dx + currentRadius * cos(startAngle),
        center.dy + currentRadius * sin(startAngle),
      );
      final endPoint = Offset(
        center.dx + currentRadius * cos(endAngle),
        center.dy + currentRadius * sin(endAngle),
      );

      // Prepare and position the label text at the start endpoint.
      final labelPainter = TextPainter(
        text: TextSpan(
          text: chart.label,
          style: TextStyle(
              color: Colors.black,
              fontSize: textFontSize,
              fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      final labelDirection = (startPoint - center);
      final labelUnit = labelDirection / labelDirection.distance;
      final labelOffset = startPoint +
          labelUnit * textPadding -
          Offset(labelPainter.width / 2, labelPainter.height / 2) +
          Offset(0, extraVerticalOffset);

      // Prepare and position the value text at the end endpoint.
      final valueText = "${chart.value.toStringAsFixed(2)} µm";
      final valuePainter = TextPainter(
        text: TextSpan(
          text: valueText,
          style: TextStyle(
              color: Colors.black,
              fontSize: textFontSize,
              fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      valuePainter.layout();
      final valueDirection = (endPoint - center);
      final valueUnit = valueDirection / valueDirection.distance;
      final valueOffset = endPoint +
          valueUnit * textPadding -
          Offset(valuePainter.width / 2, valuePainter.height / 2) +
          Offset(0, extraVerticalOffset);

      // Paint the texts.
      labelPainter.paint(canvas, labelOffset);
      valuePainter.paint(canvas, valueOffset);

      // Update the current radius for the next inner ring.
      currentRadius -= (strokeWidth + spacing);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
