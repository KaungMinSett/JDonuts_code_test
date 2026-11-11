import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';

class OnboardingEntrance extends StatelessWidget {
  const OnboardingEntrance({
    required this.curve,
    required this.child,
    super.key,
  });

  final Curve curve;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppMotion.onboardingEntranceDuration,
      curve: curve,
      child: child,
      builder: (_, progress, child) => Opacity(
        opacity: progress,
        child: Transform.translate(
          offset: Offset(0, AppMotion.onboardingSlideDistance * (1 - progress)),
          child: child,
        ),
      ),
    );
  }
}
