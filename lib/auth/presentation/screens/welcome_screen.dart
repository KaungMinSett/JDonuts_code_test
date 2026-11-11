import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/welcome_artwork.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  static const _artworkHeightPerWidth = 1.64;
  static const _artworkViewportFraction = 0.72;

  late final _entrance = AnimationController(
    vsync: this,
    duration: AppMotion.welcomeEntranceDuration,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Show the final layout immediately when the device requests less motion.
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (!_entrance.isAnimating && !_entrance.isCompleted) {
      _entrance.forward();
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SizedBox.expand(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: AppTheme.welcomeBackground,
            ),
            child: SafeArea(
              top: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final artworkHeight = math.min(
                    constraints.maxWidth * _artworkHeightPerWidth,
                    constraints.maxHeight * _artworkViewportFraction,
                  );
                  return SingleChildScrollView(
                    // Let the text and action scroll on small screens at large text sizes.
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: artworkHeight,
                            child: WelcomeArtwork(entrance: _entrance),
                          ),
                          _WelcomeActions(entrance: _entrance),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeActions extends StatelessWidget {
  const _WelcomeActions({required this.entrance});

  static const _padding = EdgeInsets.fromLTRB(32, 0, 32, 36);

  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final titleProgress = entrance.drive(
      CurveTween(curve: AppMotion.welcomeTitleInterval),
    );

    return Padding(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The title starts its fade and lift once the last tile settles.
          SlideTransition(
            position: titleProgress.drive(
              Tween(
                begin: const Offset(0, AppMotion.welcomeTitleSlideFraction),
                end: Offset.zero,
              ),
            ),
            child: FadeTransition(
              opacity: titleProgress,
              child: Text(
                strings.welcomeTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: strings.welcomeExplore,
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}
