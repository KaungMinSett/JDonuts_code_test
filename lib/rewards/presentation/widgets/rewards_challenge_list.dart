import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/rewards_repository.dart';
import 'reward_challenge_card.dart';

class RewardsChallengeList extends StatelessWidget {
  const RewardsChallengeList({
    super.key,
    required this.challenges,
    required this.entrance,
  });

  final List<RewardChallenge> challenges;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: AppTheme.catalogContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppTheme.homeSectionTitleSpacing,
        children: [
          if (challenges.isEmpty) Text(l10n.rewardsChallengesEmpty),
          for (final (index, challenge) in challenges.indexed)
            _ChallengeEntrance(
              key: ValueKey(challenge.id),
              progress: entrance.drive(
                CurveTween(
                  curve: AppMotion.rewardsChallengeInterval(
                    index,
                    challenges.length,
                  ),
                ),
              ),
              challenge: challenge,
            ),
        ],
      ),
    );
  }
}

class _ChallengeEntrance extends StatelessWidget {
  const _ChallengeEntrance({
    super.key,
    required this.progress,
    required this.challenge,
  });

  final Animation<double> progress;
  final RewardChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final entrance = progress.drive(
      CurveTween(curve: AppMotion.rewardsChallengeEntranceCurve),
    );
    // Lift and fade in each card on its own part of the shared timeline.
    return SlideTransition(
      position: entrance.drive(
        Tween(
          begin: const Offset(0, AppMotion.rewardsChallengeSlideFraction),
          end: Offset.zero,
        ),
      ),
      child: FadeTransition(
        opacity: entrance,
        child: RewardChallengeCard(challenge: challenge, entrance: progress),
      ),
    );
  }
}
