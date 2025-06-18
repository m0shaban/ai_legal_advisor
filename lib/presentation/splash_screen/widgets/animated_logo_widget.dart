import 'dart:math' as dart;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

// lib/presentation/splash_screen/widgets/animated_logo_widget.dart

class AnimatedLogoWidget extends StatefulWidget {
  const AnimatedLogoWidget({super.key});

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _rotationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow effect
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 35.w * _pulseAnimation.value,
              height: 35.w * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentLight.withAlpha(77),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            );
          },
        ),

        // AI Circuit pattern background
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentLight.withAlpha(128),
                    width: 2,
                  ),
                ),
                child: CustomPaint(
                  painter: CircuitPatternPainter(),
                ),
              ),
            );
          },
        ),

        // Main logo
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(26),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Scales of justice base
                CustomPaint(
                  size: Size(20.w, 20.w),
                  painter: ScalesOfJusticePainter(),
                ),

                // AI integration elements
                Positioned(
                  top: 2.w,
                  right: 2.w,
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.accentLight,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentLight.withAlpha(128),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CircuitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accentLight.withAlpha(77)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw circuit-like patterns
    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159 * 2) / 8;
      final startPoint = Offset(
        center.dx + (radius * 0.3) * cos(angle),
        center.dy + (radius * 0.3) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius * 0.8) * cos(angle),
        center.dy + (radius * 0.8) * sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);

      // Draw small circuit nodes
      canvas.drawCircle(endPoint, 2, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ScalesOfJusticePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryLight
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final scaleWidth = size.width * 0.15;
    final scaleHeight = size.height * 0.1;

    // Draw central pillar
    canvas.drawLine(
      Offset(center.dx, center.dy - size.height * 0.2),
      Offset(center.dx, center.dy + size.height * 0.2),
      paint,
    );

    // Draw horizontal beam
    canvas.drawLine(
      Offset(center.dx - size.width * 0.25, center.dy - size.height * 0.05),
      Offset(center.dx + size.width * 0.25, center.dy - size.height * 0.05),
      paint,
    );

    // Draw left scale
    final leftScaleCenter =
        Offset(center.dx - size.width * 0.2, center.dy + size.height * 0.05);
    _drawScale(canvas, leftScaleCenter, scaleWidth, scaleHeight, paint);

    // Draw right scale
    final rightScaleCenter =
        Offset(center.dx + size.width * 0.2, center.dy + size.height * 0.05);
    _drawScale(canvas, rightScaleCenter, scaleWidth, scaleHeight, paint);

    // Draw connecting chains
    canvas.drawLine(
      Offset(center.dx - size.width * 0.25, center.dy - size.height * 0.05),
      leftScaleCenter,
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + size.width * 0.25, center.dy - size.height * 0.05),
      rightScaleCenter,
      paint,
    );
  }

  void _drawScale(
      Canvas canvas, Offset center, double width, double height, Paint paint) {
    final rect = Rect.fromCenter(center: center, width: width, height: height);
    canvas.drawArc(rect, 0, 3.14159, false, paint);

    // Draw scale base
    canvas.drawLine(
      Offset(center.dx - width / 2, center.dy),
      Offset(center.dx + width / 2, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper function for cos
double cos(double radians) {
  return dart.cos(radians);
}

// Helper function for sin
double sin(double radians) {
  return dart.sin(radians);
}

// Import for math functions