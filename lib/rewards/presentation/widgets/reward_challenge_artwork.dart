import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../domain/rewards_repository.dart';

class RewardChallengeArtwork extends StatelessWidget {
  const RewardChallengeArtwork({
    super.key,
    required this.challenge,
    required this.progress,
  });

  static const _coffeeChallengeId = 'coffee';

  final RewardChallenge challenge;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final imageAsset = challenge.imageAsset;
    final isCoffee = challenge.id == _coffeeChallengeId;
    final target = (challenge.completed / challenge.target).clamp(0.0, 1.0);
    final photo = Padding(
      padding: const EdgeInsets.all(8),
      child: imageAsset == null
          ? Icon(isCoffee ? Icons.local_cafe_outlined : Icons.donut_large)
          : CatalogImage(assetPath: imageAsset, fit: BoxFit.contain),
    );
    return ExcludeSemantics(
      // The card already announces its progress as text.
      child: AspectRatio(
        aspectRatio: 1,
        child: isCoffee
            ? CustomPaint(
                foregroundPainter: _CoffeeProgressPainter(
                  progress: progress,
                  target: target,
                ),
                child: photo,
              )
            : _DonutColorReveal(
                photo: photo,
                progress: progress,
                target: target,
              ),
      ),
    );
  }
}

class _DonutColorReveal extends StatelessWidget {
  const _DonutColorReveal({
    required this.photo,
    required this.progress,
    required this.target,
  });

  // Map each RGB channel to the same luminance, preserving the alpha channel.
  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  final Widget photo;
  final Animation<double> progress;
  final double target;

  @override
  Widget build(BuildContext context) {
    // Reveal the color photo over a grayscale copy as each quarter fills.
    return Stack(
      fit: StackFit.expand,
      children: [
        ColorFiltered(colorFilter: _grayscale, child: photo),
        ClipPath(
          clipper: _DonutProgressClipper(progress: progress, target: target),
          child: photo,
        ),
      ],
    );
  }
}

class _DonutProgressClipper extends CustomClipper<Path> {
  _DonutProgressClipper({required this.progress, required this.target})
    : super(reclip: progress);

  final Animation<double> progress;
  final double target;

  @override
  Path getClip(Size size) {
    final fraction = progress.value * target;
    if (fraction <= 0) return Path();
    if (fraction >= 1) return Path()..addRect(Offset.zero & size);

    // The diagonal radius lets the slice reach all four corners of the photo.
    final center = size.center(Offset.zero);
    final bounds = Rect.fromCircle(center: center, radius: center.distance);
    return Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(bounds, -math.pi / 2, 2 * math.pi * fraction, false)
      ..close();
  }

  @override
  bool shouldReclip(_DonutProgressClipper oldClipper) =>
      progress != oldClipper.progress || target != oldClipper.target;
}

class _CoffeeProgressPainter extends CustomPainter {
  _CoffeeProgressPainter({required this.progress, required this.target})
    : super(repaint: progress);

  static const _strokeWidth = 6.0;
  static const _startAngle = math.pi;
  static const _trackSweep = math.pi;

  final Animation<double> progress;
  final double target;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).deflate(_strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;

    // Draw the upper half of the track over the coffee photo.
    canvas.drawArc(
      bounds,
      _startAngle,
      _trackSweep,
      false,
      paint..color = AppTheme.catalogBackground,
    );
    final sweep = _trackSweep * target * progress.value;
    if (sweep <= 0) return;
    canvas.drawArc(
      bounds,
      _startAngle,
      sweep,
      false,
      paint..color = AppTheme.orangeBadgeBackground,
    );
  }

  @override
  bool shouldRepaint(_CoffeeProgressPainter oldDelegate) =>
      progress != oldDelegate.progress || target != oldDelegate.target;
}
