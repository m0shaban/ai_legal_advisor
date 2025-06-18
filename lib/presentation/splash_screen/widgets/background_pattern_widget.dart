import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/splash_screen/widgets/background_pattern_widget.dart

class BackgroundPatternWidget extends StatefulWidget {
  const BackgroundPatternWidget({super.key});

  @override
  State<BackgroundPatternWidget> createState() =>
      _BackgroundPatternWidgetState();
}

class _BackgroundPatternWidgetState extends State<BackgroundPatternWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryLight,
            AppTheme.primaryLight.withBlue(80),
            AppTheme.primaryVariantLight,
          ],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: IslamicPatternPainter(_animation.value),
            size: Size(100.w, 100.h),
          );
        },
      ),
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  final double animationValue;

  IslamicPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentLight.withAlpha(20)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final patternPaint = Paint()
      ..color = Colors.white.withAlpha(13)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Draw geometric Islamic patterns
    _drawGeometricPattern(canvas, size, paint, patternPaint);

    // Draw subtle circuit-like elements
    _drawCircuitElements(canvas, size, paint);
  }

  void _drawGeometricPattern(
      Canvas canvas, Size size, Paint paint, Paint patternPaint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final patternSize = size.width * 0.15;

    // Draw hexagonal pattern grid
    for (int i = -2; i <= 2; i++) {
      for (int j = -3; j <= 3; j++) {
        final offsetX = centerX + (i * patternSize * 1.5);
        final offsetY = centerY +
            (j * patternSize * 0.866) +
            (i.isOdd ? patternSize * 0.433 : 0);

        if (offsetX >= -patternSize &&
            offsetX <= size.width + patternSize &&
            offsetY >= -patternSize &&
            offsetY <= size.height + patternSize) {
          _drawHexagon(canvas, Offset(offsetX, offsetY), patternSize * 0.3,
              patternPaint);

          // Add star pattern in center of some hexagons
          if ((i + j) % 2 == 0) {
            _drawStar(
                canvas, Offset(offsetX, offsetY), patternSize * 0.15, paint);
          }
        }
      }
    }
  }

  void _drawCircuitElements(Canvas canvas, Size size, Paint paint) {
    // Draw subtle circuit-like connections
    final circuitPaint = Paint()
      ..color = AppTheme.accentLight
          .withOpacity(0.1 + (sin(animationValue * 2 * 3.14159) * 0.05))
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw animated circuit lines
    for (int i = 0; i < 5; i++) {
      final startX = size.width * (0.1 + (i * 0.2));
      final startY = size.height * 0.2;
      final endX = size.width * (0.15 + (i * 0.2));
      final endY = size.height * 0.8;

      final animatedStartY =
          startY + (sin(animationValue * 2 * 3.14159 + i) * 20);
      final animatedEndY = endY + (cos(animationValue * 2 * 3.14159 + i) * 20);

      canvas.drawLine(
        Offset(startX, animatedStartY),
        Offset(endX, animatedEndY),
        circuitPaint,
      );

      // Draw connection nodes
      canvas.drawCircle(
        Offset(startX, animatedStartY),
        2,
        circuitPaint..style = PaintingStyle.fill,
      );
      circuitPaint.style = PaintingStyle.stroke;
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * 3.14159 * 2) / 6;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    const double innerRadius = 0.5;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159) / points;
      final currentRadius = (i % 2 == 0) ? radius : radius * innerRadius;
      final x = center.dx + currentRadius * cos(angle);
      final y = center.dy + currentRadius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is IslamicPatternPainter &&
        oldDelegate.animationValue != animationValue;
  }
}

// Helper functions for trigonometry
double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);