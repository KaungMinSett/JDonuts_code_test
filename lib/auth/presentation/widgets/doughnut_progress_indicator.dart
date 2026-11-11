import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class DoughnutProgressIndicator extends StatelessWidget {
  const DoughnutProgressIndicator({required this.progress, super.key})
    : assert(progress >= 0 && progress <= 1);

  static const _diameter = 32.0;
  static const _completedAnimationValue = 1.25;

  /// A value from 0 to 1. At 1 the ring closes and shows a check mark.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final progressColor = Theme.of(context).colorScheme.secondary;
    final locale = Localizations.localeOf(context).toString();
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    // Reserve the last part of the animation for closing the ring's center.
    final animationTarget = progress == 1 ? _completedAnimationValue : progress;

    return Semantics(
      label: AppLocalizations.of(context)!.doughnutProgress,
      value: NumberFormat.percentPattern(locale).format(progress),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: animationTarget),
        duration: reduceMotion
            ? Duration.zero
            : AppMotion.doughnutProgressDuration,
        curve: AppMotion.doughnutProgressCurve,
        builder: (context, animationValue, checkMark) {
          final sweep = math.min(animationValue, 1.0);
          final completion =
              (animationValue - sweep) / (_completedAnimationValue - 1);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size.square(_diameter),
                painter: _DoughnutRingPainter(
                  sweep: sweep,
                  completion: completion,
                  progressColor: progressColor,
                ),
              ),
              if (completion > 0)
                Opacity(opacity: completion, child: checkMark),
            ],
          );
        },
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: AppTheme.authControlSurface,
        ),
      ),
    );
  }
}

class _DoughnutRingPainter extends CustomPainter {
  const _DoughnutRingPainter({
    required this.sweep,
    required this.completion,
    required this.progressColor,
  });

  static const _ringWidth = 8.0;

  final double sweep;
  final double completion;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final progressPaint = Paint()..color = progressColor;

    if (completion == 1) {
      canvas.drawCircle(center, radius, progressPaint);
      return;
    }

    // Expand the stroke inward so the outer edge stays fixed as the hole closes.
    final strokeWidth = _ringWidth + (radius - _ringWidth) * completion;
    final strokeRadius = radius - strokeWidth / 2;
    final trackPaint = Paint()
      ..color = AppTheme.doughnutProgressTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, strokeRadius, trackPaint);

    progressPaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: strokeRadius),
      -math.pi / 2,
      math.pi * 2 * sweep,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_DoughnutRingPainter oldDelegate) =>
      oldDelegate.sweep != sweep ||
      oldDelegate.completion != completion ||
      oldDelegate.progressColor != progressColor;
}
