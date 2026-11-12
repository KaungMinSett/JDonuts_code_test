import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_motion.dart';
import '../../app/config/app_theme.dart';
import '../../core/domain/member_profile.dart';
import '../../core/domain/result.dart';
import '../../core/widgets/catalog_load_error.dart';
import '../../core/widgets/count_badge.dart';
import '../../home/presentation/home_providers.dart';
import '../../l10n/app_localizations.dart';
import '../domain/rewards_repository.dart';
import 'rewards_providers.dart';
import 'widgets/rewards_challenge_list.dart';
import 'widgets/rewards_points_ring.dart';
import 'widgets/rewards_tier_ladder.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  static const routeName = 'rewards';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = ref.watch(memberProfileProvider);
    final challenges = ref.watch(rewardChallengesProvider);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rewardsTitle)),
      backgroundColor: AppTheme.catalogBackground,
      body: SafeArea(
        top: false,
        child: switch ((member, challenges)) {
          (
            AsyncData(value: Success(value: final MemberProfile profile)),
            AsyncData(value: Success(value: final List<RewardChallenge> rows)),
          ) =>
            _RewardsContent(member: profile, challenges: rows),
          (AsyncData(value: Failure()) || AsyncError(), _) ||
          (_, AsyncData(value: Failure()) || AsyncError()) => CatalogLoadError(
            onRetry: () {
              ref.invalidate(memberProfileProvider);
              ref.invalidate(rewardChallengesProvider);
            },
          ),
          (AsyncData(value: Success(value: null)), _) => Center(
            child: Text(l10n.homeMemberEmpty),
          ),
          _ => Center(child: Text(l10n.catalogLoading)),
        },
      ),
    );
  }
}

class _RewardsContent extends StatefulWidget {
  const _RewardsContent({required this.member, required this.challenges});

  final MemberProfile member;
  final List<RewardChallenge> challenges;

  @override
  State<_RewardsContent> createState() => _RewardsContentState();
}

class _RewardsContentState extends State<_RewardsContent>
    with SingleTickerProviderStateMixin {
  late final _entrance = AnimationController(
    vsync: this,
    duration: AppMotion.rewardsEntranceDuration,
  );
  late final _pointsProgress = _entrance.drive(
    CurveTween(curve: AppMotion.rewardsPointsCurve),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start after the data is ready and show final values under Reduce Motion.
    if (MediaQuery.disableAnimationsOf(context)) {
      _entrance.value = 1;
    } else if (_entrance.isDismissed) {
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
    return ListView(
      children: [
        _RewardsSummary(
          member: widget.member,
          challengeCount: widget.challenges.length,
          entrance: _entrance,
          pointsProgress: _pointsProgress,
        ),
        RewardsChallengeList(
          challenges: widget.challenges,
          entrance: _entrance,
        ),
      ],
    );
  }
}

class _RewardsSummary extends StatelessWidget {
  const _RewardsSummary({
    required this.member,
    required this.challengeCount,
    required this.entrance,
    required this.pointsProgress,
  });

  final MemberProfile member;
  final int challengeCount;
  final Animation<double> entrance;
  final Animation<double> pointsProgress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ColoredBox(
      color: AppTheme.productCardSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Use the number of seeded challenges for the demo badge.
          ScaleTransition(
            scale: entrance.drive(
              CurveTween(curve: AppMotion.rewardsBadgeInterval),
            ),
            child: CountBadge(
              count: challengeCount,
              child: Text(l10n.rewardsLabel),
            ),
          ),
          Padding(
            padding: AppTheme.catalogContentPadding,
            child: Row(
              children: [
                Expanded(
                  child: RewardsTierLadder(member: member, entrance: entrance),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RewardsPointsRing(
                    points: member.points,
                    tierProgress: member.tierProgress,
                    progress: pointsProgress,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
