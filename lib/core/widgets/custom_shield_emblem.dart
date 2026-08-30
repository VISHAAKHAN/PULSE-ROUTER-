import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomShieldEmblem extends StatelessWidget {
  final double width;
  final double height;

  const CustomShieldEmblem({
    super.key,
    this.width = 64,
    this.height = 76,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.emergencyRed.withValues(alpha: 0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(width, height),
        painter: _ShieldPainter(),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Shield Path
    final outerPath = Path();
    outerPath.moveTo(w * 0.5, h * 0.02);
    outerPath.lineTo(w * 0.06, h * 0.16);
    outerPath.lineTo(w * 0.06, h * 0.45);
    outerPath.cubicTo(w * 0.06, h * 0.70, w * 0.25, h * 0.94, w * 0.5, h * 0.98);
    outerPath.cubicTo(w * 0.75, h * 0.94, w * 0.94, h * 0.70, w * 0.94, h * 0.45);
    outerPath.lineTo(w * 0.94, h * 0.16);
    outerPath.close();

    // Fill Outer Shield
    final outerFillPaint = Paint()
      ..color = const Color(0xFF0A1424)
      ..style = PaintingStyle.fill;
    canvas.drawPath(outerPath, outerFillPaint);

    // Stroke Outer Red Border
    final outerStrokePaint = Paint()
      ..color = AppColors.emergencyRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(outerPath, outerStrokePaint);

    // Inner Shield Path
    final innerPath = Path();
    innerPath.moveTo(w * 0.5, h * 0.08);
    innerPath.lineTo(w * 0.13, h * 0.20);
    innerPath.lineTo(w * 0.13, h * 0.45);
    innerPath.cubicTo(w * 0.13, h * 0.67, w * 0.29, h * 0.88, w * 0.5, h * 0.92);
    innerPath.cubicTo(w * 0.71, h * 0.88, w * 0.87, h * 0.67, w * 0.87, h * 0.45);
    innerPath.lineTo(w * 0.87, h * 0.20);
    innerPath.close();

    // Fill Inner Shield
    final innerFillPaint = Paint()
      ..color = const Color(0xFF0C192D)
      ..style = PaintingStyle.fill;
    canvas.drawPath(innerPath, innerFillPaint);

    // Inner White Border
    final innerStrokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(innerPath, innerStrokePaint);

    // Star of Life / Rod of Asclepius in White
    final starPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Vertical line
    canvas.drawLine(Offset(w * 0.5, h * 0.24), Offset(w * 0.5, h * 0.68), starPaint);
    // Diagonal lines
    canvas.drawLine(Offset(w * 0.32, h * 0.33), Offset(w * 0.68, h * 0.59), starPaint);
    canvas.drawLine(Offset(w * 0.32, h * 0.59), Offset(w * 0.68, h * 0.33), starPaint);

    // Red Center Dot
    final dotPaint = Paint()
      ..color = AppColors.emergencyRed
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.29), 2.5, dotPaint);

    // Red ECG Heartbeat Wave crossing through center
    final ecgPaint = Paint()
      ..color = AppColors.emergencyRed
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ecgPath = Path();
    ecgPath.moveTo(w * 0.10, h * 0.46);
    ecgPath.lineTo(w * 0.38, h * 0.46);
    ecgPath.lineTo(w * 0.42, h * 0.37);
    ecgPath.lineTo(w * 0.48, h * 0.57);
    ecgPath.lineTo(w * 0.55, h * 0.41);
    ecgPath.lineTo(w * 0.60, h * 0.50);
    ecgPath.lineTo(w * 0.64, h * 0.46);
    ecgPath.lineTo(w * 0.90, h * 0.46);

    canvas.drawPath(ecgPath, ecgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
