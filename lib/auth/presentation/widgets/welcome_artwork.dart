import 'package:flutter/material.dart';

import '../../../app/config/app_media.dart';
import '../../../app/config/app_motion.dart';

class WelcomeArtwork extends StatelessWidget {
  const WelcomeArtwork({required this.entrance, super.key});

  static const _artworkMask = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Colors.white, Colors.transparent],
    stops: [0, 0.8, 1],
  );
  static const _tileGap = 22.0;
  static const _rightColumnInset = 24.0;
  static const _rightColumnDrop = 42.0;

  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: _artworkMask.createShader,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tileWidth =
              (constraints.maxWidth + _rightColumnInset - _tileGap) / 2;
          final tileHeight = (constraints.maxHeight - _tileGap) / 2;
          final lowerRowTop = tileHeight + _tileGap;

          // Offset the right column and let the viewport crop its outer edge.
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: tileWidth,
                height: tileHeight,
                child: _WelcomeTile(
                  entrance: entrance,
                  interval: AppMotion.welcomeFirstTileInterval,
                  photoCrop: const Alignment(0.8, -1),
                  entersFromLeft: true,
                ),
              ),
              Positioned(
                top: _rightColumnDrop,
                left: tileWidth + _tileGap,
                width: tileWidth,
                height: tileHeight,
                child: _WelcomeTile(
                  entrance: entrance,
                  interval: AppMotion.welcomeSecondTileInterval,
                  photoCrop: const Alignment(0.16, -0.45),
                  entersFromLeft: false,
                ),
              ),
              Positioned(
                top: lowerRowTop,
                left: 0,
                width: tileWidth,
                height: tileHeight,
                child: _WelcomeTile(
                  entrance: entrance,
                  interval: AppMotion.welcomeThirdTileInterval,
                  photoCrop: const Alignment(-0.23, 0.26),
                  entersFromLeft: true,
                ),
              ),
              Positioned(
                top: lowerRowTop + _rightColumnDrop,
                left: tileWidth + _tileGap,
                width: tileWidth,
                height: tileHeight,
                child: _WelcomeTile(
                  entrance: entrance,
                  interval: AppMotion.welcomeFourthTileInterval,
                  photoCrop: const Alignment(-0.5, 1),
                  entersFromLeft: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WelcomeTile extends StatelessWidget {
  const _WelcomeTile({
    required this.entrance,
    required this.interval,
    required this.photoCrop,
    required this.entersFromLeft,
  });

  static const _radius = BorderRadius.all(Radius.circular(24));
  static const _photoScale = 2.4;

  final Animation<double> entrance;
  final Interval interval;
  final Alignment photoCrop;
  final bool entersFromLeft;

  @override
  Widget build(BuildContext context) {
    final progress = entrance.drive(CurveTween(curve: interval));
    final startOffset = entersFromLeft
        ? -AppMotion.welcomeTileSlideFraction
        : AppMotion.welcomeTileSlideFraction;

    return SlideTransition(
      position: progress.drive(
        Tween(begin: Offset(startOffset, 0), end: Offset.zero),
      ),
      child: FadeTransition(
        opacity: progress,
        child: ClipRRect(
          borderRadius: _radius,
          // Crop the bundled photo differently in each tile.
          child: Transform.scale(
            scale: _photoScale,
            alignment: photoCrop,
            child: Image.asset(
              AppMedia.onboardingHero,
              alignment: photoCrop,
              fit: BoxFit.cover,
              excludeFromSemantics: true,
              errorBuilder: (context, _, _) => ColoredBox(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
