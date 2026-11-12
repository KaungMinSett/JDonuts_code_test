import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/rewards_repository.dart';
import 'rewards_challenge_list.dart';

class RewardsTabs extends StatelessWidget {
  const RewardsTabs({
    super.key,
    required this.challenges,
    required this.entrance,
  });

  final List<RewardChallenge> challenges;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          // Center the pills on the boundary between the summary and cards.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.productCardSurface, AppTheme.catalogBackground],
              stops: [0.5, 0.5],
            ),
          ),
          child: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            dividerHeight: 0,
            labelPadding: const EdgeInsets.symmetric(horizontal: 4),
            indicatorWeight: 0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorAnimation: TabIndicatorAnimation.linear,
            indicator: ShapeDecoration(
              color: colors.primary,
              shape: const StadiumBorder(),
            ),
            labelColor: colors.onSurface,
            unselectedLabelColor: colors.onSurface,
            tabs: [
              _RewardsTabButton(label: l10n.rewardsChallengesTitle, index: 0),
              _RewardsTabButton(label: l10n.rewardsGiftTab, index: 1),
            ],
          ),
        ),
        _RewardsTabContent(challenges: challenges, entrance: entrance),
      ],
    );
  }
}

class _RewardsTabButton extends StatelessWidget {
  const _RewardsTabButton({required this.label, required this.index});

  final String label;
  final int index;

  @override
  Widget build(BuildContext context) {
    final selection = DefaultTabController.of(context).animation!;
    return Tab(
      height: 40,
      child: AnimatedBuilder(
        animation: selection,
        // Fade the gray fill to reveal the cyan indicator moving behind it.
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(widthFactor: 1, child: Text(label)),
        ),
        builder: (context, label) => DecoratedBox(
          decoration: ShapeDecoration(
            color: AppTheme.catalogBackground.withValues(
              alpha: (selection.value - index).abs().clamp(0.0, 1.0),
            ),
            shape: const StadiumBorder(
              side: BorderSide(color: AppTheme.productCardSurface, width: 2),
            ),
          ),
          child: label,
        ),
      ),
    );
  }
}

class _RewardsTabContent extends StatelessWidget {
  const _RewardsTabContent({required this.challenges, required this.entrance});

  final List<RewardChallenge> challenges;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final tabs = DefaultTabController.of(context);
    // Read the same selection that drives the pill, and rebuild only the panel.
    return AnimatedBuilder(
      animation: tabs,
      builder: (context, _) => AnimatedSwitcher(
        duration: tabs.animationDuration,
        switchInCurve: AppMotion.rewardsTabContentCurve,
        switchOutCurve: AppMotion.rewardsTabContentCurve,
        child: tabs.index == 0
            ? RewardsChallengeList(challenges: challenges, entrance: entrance)
            : const _RewardsGiftEmpty(),
      ),
    );
  }
}

class _RewardsGiftEmpty extends StatelessWidget {
  const _RewardsGiftEmpty();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: AppTheme.catalogContentPadding,
      color: AppTheme.productCardSurface,
      elevation: 0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: AppTheme.catalogContentPadding,
          child: Text(
            AppLocalizations.of(context)!.rewardsGiftsEmpty,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
