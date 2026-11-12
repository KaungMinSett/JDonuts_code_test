import 'package:flutter/animation.dart';

abstract final class AppMotion {
  static const onboardingEntranceDuration = Duration(milliseconds: 650);
  static const onboardingArtworkCurve = Curves.easeOutCubic;
  static const onboardingTitleCurve = Interval(
    0.18,
    0.8,
    curve: Curves.easeOut,
  );
  static const onboardingActionsCurve = Interval(
    0.35,
    1,
    curve: Curves.easeOut,
  );
  static const onboardingSlideDistance = 12.0;
  static const welcomeEntranceDuration = Duration(milliseconds: 900);
  static const welcomeFirstTileInterval = Interval(
    0,
    0.38,
    curve: Curves.easeOutCubic,
  );
  static const welcomeSecondTileInterval = Interval(
    0.1,
    0.48,
    curve: Curves.easeOutCubic,
  );
  static const welcomeThirdTileInterval = Interval(
    0.2,
    0.58,
    curve: Curves.easeOutCubic,
  );
  static const welcomeFourthTileInterval = Interval(
    0.3,
    0.68,
    curve: Curves.easeOutCubic,
  );
  static const welcomeTitleInterval = Interval(
    0.68,
    1,
    curve: Curves.easeOutCubic,
  );
  static const welcomeTileSlideFraction = 0.22;
  static const welcomeTitleSlideFraction = 0.18;
  static const doughnutProgressDuration = Duration(milliseconds: 350);
  static const doughnutProgressCurve = Curves.easeInOutCubic;
  static const otpErrorShakeDuration = Duration(milliseconds: 300);
  static const otpErrorShakeDistance = 8.0;
  static const otpFeedbackDuration = Duration(milliseconds: 150);
  static const otpFeedbackCurve = Curves.easeOut;
  static const otpBoxFocusDuration = Duration(milliseconds: 150);
  static const otpBoxFocusCurve = Curves.easeOut;
  static const buttonLoadingDuration = Duration(milliseconds: 180);
  static const buttonLoadingCurve = Curves.easeInOut;
  static const buttonPressDuration = Duration(milliseconds: 120);
  static const buttonPressCurve = Curves.easeOut;
  static const buttonPressedScale = 0.97;
  static const productQuantityChangeDuration = Duration(milliseconds: 160);
  static const homeSkeletonShimmerDuration = Duration(milliseconds: 1400);
  static const mainTabSlideDuration = Duration(milliseconds: 250);
  static const mainTabSlideCurve = Curves.easeInOutCubic;
  static const rewardsEntranceDuration = Duration(milliseconds: 1250);
  static const rewardsTabTransitionDuration = Duration(milliseconds: 240);
  static const rewardsTabContentCurve = Curves.easeOutCubic;
  static const rewardsPointsCurve = Curves.easeOutCubic;
  static const rewardsTierIntervals = [
    Interval(0.05, 0.30, curve: Curves.easeOut),
    Interval(0.18, 0.43, curve: Curves.easeOut),
    Interval(0.31, 0.56, curve: Curves.easeOut),
  ];
  static const rewardsTierFillInterval = Interval(
    0.30,
    0.80,
    curve: Curves.easeOutCubic,
  );
  static const rewardsBadgeInterval = Interval(
    0.08,
    0.42,
    curve: Curves.easeOutBack,
  );
  static const rewardsChallengeSlideFraction = 0.10;
  static const rewardsChallengeEntranceCurve = Curves.easeOutCubic;
  static const rewardsChallengeArtworkInterval = Interval(
    0.15,
    1,
    curve: Curves.easeOutCubic,
  );
  static const rewardsEarnPulseInterval = Interval(0.40, 1);
  static const rewardsEarnPulseScale = 1.08;
  static const rewardsEarnPulseCurve = Curves.easeInOut;
  static const _rewardsFirstChallengeStart = 0.30;
  static const _rewardsLastChallengeStart = 0.68;
  static const _rewardsChallengeIntervalLength = 0.32;

  static Interval rewardsChallengeInterval(int index, int count) {
    // Spread the card starts across the same timeline for any list length.
    final position = count > 1 ? index / (count - 1) : 0.0;
    final start =
        _rewardsFirstChallengeStart +
        (_rewardsLastChallengeStart - _rewardsFirstChallengeStart) * position;
    return Interval(start, start + _rewardsChallengeIntervalLength);
  }
}
