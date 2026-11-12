import 'package:flutter/material.dart';

import '../../../app/config/app_motion.dart';
import '../../../app/config/app_theme.dart';
import '../../../core/domain/member_profile.dart';
import '../../../l10n/app_localizations.dart';

class RewardsTierLadder extends StatelessWidget {
  const RewardsTierLadder({
    super.key,
    required this.member,
    required this.entrance,
  });

  final MemberProfile member;
  final Animation<double> entrance;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tiers = [
      (id: 'Silver', label: l10n.rewardsSilver, color: AppTheme.rewardsSilver),
      (id: 'Gold', label: l10n.rewardsGold, color: AppTheme.rewardsGold),
      (
        id: 'Platinum',
        label: l10n.rewardsPlatinum,
        color: AppTheme.rewardsPlatinum,
      ),
    ];
    final lineProgress = entrance.drive(
      CurveTween(curve: AppMotion.rewardsTierFillInterval),
    );
    return Column(
      children: [
        for (final (index, tier) in tiers.indexed)
          FadeTransition(
            opacity: entrance.drive(
              CurveTween(curve: AppMotion.rewardsTierIntervals[index]),
            ),
            child: _TierStep(
              label: tier.label,
              description: switch (tier.id) {
                final id when id == member.tier => l10n.rewardsCurrentTier,
                final id when id == member.nextTier =>
                  l10n.rewardsTierRemaining(
                    member.nextTierPoints - member.points,
                    tier.label,
                  ),
                _ => l10n.rewardsFutureTier,
              },
              color: tier.color,
              isCurrent: tier.id == member.tier,
              hasNextTier: index < tiers.length - 1,
              tierProgress: member.tierProgress,
              lineProgress: lineProgress,
            ),
          ),
      ],
    );
  }
}

class _TierStep extends StatelessWidget {
  const _TierStep({
    required this.label,
    required this.description,
    required this.color,
    required this.isCurrent,
    required this.hasNextTier,
    required this.tierProgress,
    required this.lineProgress,
  });

  static const _markerSize = 30.0;
  static const _connectorWidth = 3.0;
  static const _stepSpacing = 52.0;

  final String label;
  final String description;
  final Color color;
  final bool isCurrent;
  final bool hasNextTier;
  final double tierProgress;
  final Animation<double> lineProgress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: hasNextTier ? _stepSpacing : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppTheme.homeSectionTitleSpacing,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.shield,
                    color: color.withValues(alpha: isCurrent ? 0.42 : 0.22),
                    size: _markerSize,
                  ),
                  Icon(Icons.shield_outlined, color: color, size: _markerSize),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(description, style: textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasNextTier)
          PositionedDirectional(
            // Anchor the line under the shield, even when the label wraps.
            start: (_markerSize - _connectorWidth) / 2,
            top: _markerSize,
            bottom: 0,
            width: _connectorWidth,
            child: ColoredBox(
              color: AppTheme.catalogBackground,
              child: isCurrent
                  ? AnimatedBuilder(
                      animation: lineProgress,
                      child: ColoredBox(color: color),
                      builder: (context, fill) => FractionallySizedBox(
                        alignment: Alignment.topCenter,
                        heightFactor: tierProgress * lineProgress.value,
                        child: fill,
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
