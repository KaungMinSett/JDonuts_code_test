import 'package:flutter/material.dart';

import '../../../app/config/app_media.dart';
import '../../../app/config/app_motion.dart';
import 'onboarding_entrance.dart';

class OnboardingArtwork extends StatelessWidget {
  const OnboardingArtwork({super.key});

  static const _artworkAspectRatio = 0.92;
  static const _artworkMask = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.white, Colors.white, Colors.transparent],
    stops: [0, 0.74, 1],
  );

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _artworkAspectRatio,
      child: ClipRect(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: _artworkMask.createShader,
          child: Image.asset(
            AppMedia.onboardingHero,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
            frameBuilder: (_, child, frame, _) {
              // Start the fade when the asset can actually be drawn.
              if (frame == null) return const SizedBox.expand();
              return OnboardingEntrance(
                curve: AppMotion.onboardingArtworkCurve,
                child: child,
              );
            },
            errorBuilder: (_, _, _) => const OnboardingEntrance(
              curve: AppMotion.onboardingArtworkCurve,
              child: _ArtworkPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtworkPlaceholder extends StatelessWidget {
  const _ArtworkPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.56,
        child: AspectRatio(
          aspectRatio: 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
