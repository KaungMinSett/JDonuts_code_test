import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class RewardsPointsRing extends StatelessWidget {
  const RewardsPointsRing({
    super.key,
    required this.points,
    required this.tierProgress,
    required this.progress,
  });

  final int points;
  final double tierProgress;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formatPoints = MaterialLocalizations.of(context).formatDecimal;
    final textTheme = Theme.of(context).textTheme;
    return AspectRatio(
      aspectRatio: 1,
      child: Semantics(
        label: l10n.rewardsTotalPoints,
        value: formatPoints(points),
        // Expose the final total while the visual number counts up.
        excludeSemantics: true,
        child: CustomPaint(
          painter: _PointsRingPainter(
            progress: progress,
            target: tierProgress,
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.rewardsTotalPoints,
                    style: textTheme.labelLarge?.copyWith(
                      color: AppTheme.rewardsPointsText,
                    ),
                  ),
                  AnimatedBuilder(
                    animation: progress,
                    builder: (context, _) => Text(
                      formatPoints((points * progress.value).round()),
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppTheme.rewardsPointsText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PointsRingPainter extends CustomPainter {
  _PointsRingPainter({
    required this.progress,
    required this.target,
    required this.color,
  }) : super(repaint: progress);

  static const _startAngle = -math.pi / 2;
  static const _sprinkleCount = 18;

  final Animation<double> progress;
  final double target;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.shortestSide * 0.21;
    final radius = (size.shortestSide - strokeWidth) / 2;
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(
      center,
      radius,
      paint..color = AppTheme.catalogBackground,
    );

    // Start at twelve o'clock and sweep clockwise toward the stored target.
    final sweep = 2 * math.pi * target * progress.value;
    if (sweep == 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      _startAngle,
      sweep,
      false,
      paint..color = color,
    );
    _paintSprinkles(canvas, center, radius, strokeWidth, sweep);
  }

  void _paintSprinkles(
    Canvas canvas,
    Offset center,
    double radius,
    double strokeWidth,
    double sweep,
  ) {
    final paint = Paint()
      ..color = Color.lerp(color, AppTheme.productCardSurface, 0.42)!
      ..strokeWidth = strokeWidth * 0.10
      ..strokeCap = StrokeCap.round;
    final step = 2 * math.pi / _sprinkleCount;
    // Keep the sprinkles inside the frosted part as the pink arc sweeps in.
    for (var index = 0; index < _sprinkleCount; index++) {
      final position = step * (index + 0.5);
      if (position > sweep) break;
      final angle = _startAngle + position;
      final radialOffset = strokeWidth * (index.isEven ? 0.20 : -0.18);
      final middle =
          center + Offset.fromDirection(angle, radius + radialOffset);
      final tilt = index.isEven ? math.pi / 5 : -math.pi / 4;
      final halfLength = Offset.fromDirection(angle + tilt, strokeWidth * 0.13);
      canvas.drawLine(middle - halfLength, middle + halfLength, paint);
    }
  }

  @override
  bool shouldRepaint(_PointsRingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      target != oldDelegate.target ||
      color != oldDelegate.color;
}
