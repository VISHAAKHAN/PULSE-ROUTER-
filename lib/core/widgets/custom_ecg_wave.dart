import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomEcgWave extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double strokeWidth;

  const CustomEcgWave({
    super.key,
    this.width = 160,
    this.height = 16,
    this.color = AppColors.emergencyRed,
    this.strokeWidth = 1.8,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _EcgWavePainter(color: color, strokeWidth: strokeWidth),
    );
  }
}

class _EcgWavePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _EcgWavePainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final midY = size.height / 2;
    final w = size.width;

    path.moveTo(0, midY);
    path.lineTo(w * 0.40, midY);
    path.lineTo(w * 0.44, midY - size.height * 0.4);
    path.lineTo(w * 0.48, midY + size.height * 0.45);
    path.lineTo(w * 0.52, midY - size.height * 0.25);
    path.lineTo(w * 0.55, midY + size.height * 0.2);
    path.lineTo(w * 0.58, midY);
    path.lineTo(w, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _EcgWavePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
