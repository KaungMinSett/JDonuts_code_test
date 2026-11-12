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
                  Text(l10n.rewardsTotalPoints),
                  AnimatedBuilder(
                    animation: progress,
                    builder: (context, _) => Text(
                      formatPoints((points * progress.value).round()),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
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

  final Animation<double> progress;
  final double target;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.shortestSide * 0.15;
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
      -math.pi / 2,
      sweep,
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_PointsRingPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      target != oldDelegate.target ||
      color != oldDelegate.color;
}
