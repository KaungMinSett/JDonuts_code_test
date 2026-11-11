import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';

class OtpErrorShake extends StatefulWidget {
  const OtpErrorShake({
    required this.wrongAttempts,
    required this.child,
    super.key,
  });

  final int wrongAttempts;
  final Widget child;

  @override
  State<OtpErrorShake> createState() => _OtpErrorShakeState();
}

class _OtpErrorShakeState extends State<OtpErrorShake>
    with SingleTickerProviderStateMixin {
  static final _shakeOffsets = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0, end: -1), weight: 1),
    TweenSequenceItem(tween: Tween(begin: -1, end: 1), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 1, end: -0.5), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -0.5, end: 0), weight: 1),
  ]);

  late final _animation = AnimationController(
    vsync: this,
    duration: AppMotion.otpErrorShakeDuration,
  );

  @override
  void didUpdateWidget(covariant OtpErrorShake oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Each rejected submission triggers one shake, including the third attempt.
    if (widget.wrongAttempts > oldWidget.wrongAttempts &&
        !MediaQuery.disableAnimationsOf(context)) {
      _animation.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => Transform.translate(
        offset: Offset(
          _shakeOffsets.evaluate(_animation) * AppMotion.otpErrorShakeDistance,
          0,
        ),
        child: child,
      ),
    );
  }
}
