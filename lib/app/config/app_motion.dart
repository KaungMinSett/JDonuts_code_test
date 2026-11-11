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
}
