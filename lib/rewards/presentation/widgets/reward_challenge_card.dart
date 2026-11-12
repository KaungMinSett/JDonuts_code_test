import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/rewards_repository.dart';
import 'reward_challenge_artwork.dart';

class RewardChallengeCard extends StatelessWidget {
  const RewardChallengeCard({
    super.key,
    required this.challenge,
    required this.entrance,
  });

  final RewardChallenge challenge;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isComplete = challenge.completed == challenge.target;
    final artworkProgress = entrance.drive(
      CurveTween(curve: AppMotion.rewardsChallengeArtworkInterval),
    );
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppTheme.productCardSurface,
        borderRadius: AppTheme.productCardRadius,
      ),
      child: Padding(
        padding: AppTheme.catalogContentPadding,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: RewardChallengeArtwork(
                challenge: challenge,
                progress: artworkProgress,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppTheme.homeSectionTitleSpacing,
                children: [
                  Text(
                    challenge.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    l10n.rewardsChallengeProgress(
                      challenge.completed,
                      challenge.target,
                    ),
                  ),
                  Wrap(
                    // Keep the points beside Earn when there is room.
                    spacing: 12,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 96,
                        child: _EarnButton(
                          label: l10n.rewardsEarn,
                          isComplete: isComplete,
                          entrance: entrance,
                        ),
                      ),
                      Text(l10n.rewardsChallengePoints(challenge.rewardPoints)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnButton extends StatelessWidget {
  const _EarnButton({
    required this.label,
    required this.isComplete,
    required this.entrance,
  });

  final String label;
  final bool isComplete;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    // Earn has press feedback only when the challenge is complete.
    final button = PrimaryButton(
      label: label,
      onPressed: isComplete ? () {} : null,
    );
    if (!isComplete) return button;

    // Grow once and return to normal during the completed card's entrance.
    final scale = entrance
        .drive(CurveTween(curve: AppMotion.rewardsEarnPulseInterval))
        .drive(
          TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween(begin: 1.0, end: AppMotion.rewardsEarnPulseScale),
              weight: 1,
            ),
            TweenSequenceItem(
              tween: Tween(begin: AppMotion.rewardsEarnPulseScale, end: 1.0),
              weight: 1,
            ),
          ]).chain(CurveTween(curve: AppMotion.rewardsEarnPulseCurve)),
        );
    return ScaleTransition(scale: scale, child: button);
  }
}
