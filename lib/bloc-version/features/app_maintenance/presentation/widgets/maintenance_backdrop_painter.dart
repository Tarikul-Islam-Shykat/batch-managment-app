import 'package:flutter/material.dart';

class MaintenanceBackdropPainter extends CustomPainter {
  final double progress;

  const MaintenanceBackdropPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF2563EB).withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.16),
      size.width * (0.18 + (progress * 0.06)),
      paint,
    );

    paint.color = const Color(0xFF2563EB).withValues(alpha: 0.04);
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.30),
      size.width * (0.12 + (progress * 0.04)),
      paint,
    );

    paint.color = const Color(0xFF2563EB).withValues(alpha: 0.03);
    canvas.drawCircle(
      Offset(size.width * 0.55, size.height * 0.82),
      size.width * (0.22 + (progress * 0.08)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant MaintenanceBackdropPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
