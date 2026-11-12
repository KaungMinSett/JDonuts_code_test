import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key, required this.child});

  final Widget child;

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: AppMotion.homeSkeletonShimmerDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Leave the shapes visible with no moving highlight under Reduce Motion.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.catalogLoading,
      child: MediaQuery.disableAnimationsOf(context)
          ? widget.child
          : AnimatedBuilder(
              animation: _controller,
              child: widget.child,
              builder: (_, child) => ShaderMask(
                // Apply the moving gradient only to the placeholder shapes.
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) {
                  final sweep = _controller.value * 4 - 2;
                  return LinearGradient(
                    begin: Alignment(sweep - 1, 0),
                    end: Alignment(sweep + 1, 0),
                    colors: const [
                      AppTheme.homeSkeletonBase,
                      AppTheme.homeSkeletonHighlight,
                      AppTheme.homeSkeletonBase,
                    ],
                  ).createShader(bounds);
                },
                child: child,
              ),
            ),
    );
  }
}

class HomeSkeletonBlock extends StatelessWidget {
  const HomeSkeletonBlock({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppTheme.homeSkeletonBase,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
