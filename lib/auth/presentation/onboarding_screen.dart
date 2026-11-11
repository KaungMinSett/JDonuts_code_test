import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/config/app_motion.dart';
import '../../app/config/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/onboarding_actions.dart';
import 'widgets/onboarding_artwork.dart';
import 'widgets/onboarding_entrance.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: AppTheme.onboardingBackground),
          child: SizedBox.expand(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [OnboardingArtwork(), _OnboardingContent()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppTheme.onboardingContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingEntrance(
            curve: AppMotion.onboardingTitleCurve,
            child: _OnboardingHeadline(),
          ),
          SizedBox(height: 32),
          OnboardingEntrance(
            curve: AppMotion.onboardingActionsCurve,
            child: OnboardingActions(),
          ),
        ],
      ),
    );
  }
}

class _OnboardingHeadline extends StatelessWidget {
  const _OnboardingHeadline();

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.onboardingHeadline,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}
