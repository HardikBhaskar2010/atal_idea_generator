import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoadingAnimationWidget extends StatefulWidget {
  const LoadingAnimationWidget({super.key});

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _gearController;
  late AnimationController _dotsController;
  late AnimationController _sparkController;
  late Animation<double> _gearRotation;
  late Animation<double> _dotsScale;
  late Animation<double> _sparkOpacity;

  @override
  void initState() {
    super.initState();

    _gearController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _sparkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _gearRotation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159,
    ).animate(CurvedAnimation(
      parent: _gearController,
      curve: Curves.linear,
    ));

    _dotsScale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _dotsController,
      curve: Curves.easeInOut,
    ));

    _sparkOpacity = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sparkController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _gearController.dispose();
    _dotsController.dispose();
    _sparkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background connecting dots
          AnimatedBuilder(
            animation: _dotsController,
            builder: (context, child) {
              return Transform.scale(
                scale: _dotsScale.value,
                child: Container(
                  width: 60.w,
                  height: 30.h,
                  child: CustomPaint(
                    painter: ConnectingDotsPainter(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      animationValue: _dotsController.value,
                    ),
                  ),
                ),
              );
            },
          ),

          // Central brain icon with rotating gears
          AnimatedBuilder(
            animation: _gearController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating gear background
                  Transform.rotate(
                    angle: _gearRotation.value,
                    child: Container(
                      width: 25.w,
                      height: 25.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: List.generate(8, (index) {
                          return Positioned(
                            top: 50 - 2,
                            left: 50 - 1,
                            child: Transform.rotate(
                              angle: (index * 3.14159 / 4),
                              child: Container(
                                width: 4,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // Central brain icon
                  Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'psychology',
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Sparks around the brain
          AnimatedBuilder(
            animation: _sparkController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: List.generate(6, (index) {
                  final angle = (index * 3.14159 * 2) / 6;
                  final radius = 20.w;
                  final x = radius * (angle.cos());
                  final y = radius * (angle.sin());

                  return Transform.translate(
                    offset: Offset(x, y),
                    child: Opacity(
                      opacity: _sparkOpacity.value,
                      child: Container(
                        width: 3.w,
                        height: 3.w,
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  colorScheme.tertiary.withValues(alpha: 0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ConnectingDotsPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  ConnectingDotsPainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.3;

    // Draw connecting lines with animation
    for (int i = 0; i < 5; i++) {
      final angle1 = (i * 3.14159 * 2) / 5;
      final angle2 = ((i + 1) * 3.14159 * 2) / 5;

      final x1 = centerX + radius * (angle1.cos());
      final y1 = centerY + radius * (angle1.sin());
      final x2 = centerX + radius * (angle2.cos());
      final y2 = centerY + radius * (angle2.sin());

      final progress = (animationValue + i * 0.2) % 1.0;
      final currentX = x1 + (x2 - x1) * progress;
      final currentY = y1 + (y2 - y1) * progress;

      canvas.drawLine(Offset(x1, y1), Offset(currentX, currentY), paint);
      canvas.drawCircle(Offset(x1, y1), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on double {
  double cos() => (this * 180 / 3.14159).cos();
  double sin() => (this * 180 / 3.14159).sin();
}
