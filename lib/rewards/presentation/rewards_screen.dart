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
import 'widgets/rewards_points_ring.dart';
import 'widgets/rewards_tabs.dart';
import 'widgets/rewards_tier_ladder.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  static const routeName = 'rewards';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final member = ref.watch(memberProfileProvider);
    final challenges = ref.watch(rewardChallengesProvider);
    final l10n = AppLocalizations.of(context)!;
    if ((member, challenges) case (
      AsyncData(value: Success(value: final MemberProfile profile)),
      AsyncData(value: Success(value: final List<RewardChallenge> rows)),
    )) {
      return _RewardsContent(member: profile, challenges: rows);
    }
    return _RewardsFrame(
      body: switch ((member, challenges)) {
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
    );
  }
}

class _RewardsFrame extends StatelessWidget {
  const _RewardsFrame({required this.body, this.badge});

  final Widget body;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.productCardSurface,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 68,
        titleSpacing: Navigator.canPop(context) ? 0 : 24,
        actionsPadding: EdgeInsets.zero,
        title: Text(
          AppLocalizations.of(context)!.rewardsTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        // Keep the badge on the same line as the title, flush with the edge.
        actions: [?badge],
      ),
      backgroundColor: AppTheme.catalogBackground,
      body: SafeArea(top: false, child: body),
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
    return _RewardsFrame(
      badge: ScaleTransition(
        scale: _entrance.drive(
          CurveTween(curve: AppMotion.rewardsBadgeInterval),
        ),
        child: CountBadge(
          count: widget.challenges.length,
          child: Text(AppLocalizations.of(context)!.rewardsLabel),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        animationDuration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.rewardsTabTransitionDuration,
        // Keep the selected tab above the scroll view so it survives scrolling.
        child: ListView(
          // Keep the white summary flush with the app bar during a pull.
          physics: const ClampingScrollPhysics(),
          children: [
            _RewardsSummary(
              member: widget.member,
              entrance: _entrance,
              pointsProgress: _pointsProgress,
            ),
            RewardsTabs(challenges: widget.challenges, entrance: _entrance),
          ],
        ),
      ),
    );
  }
}

class _RewardsSummary extends StatelessWidget {
  const _RewardsSummary({
    required this.member,
    required this.entrance,
    required this.pointsProgress,
  });

  final MemberProfile member;
  final Animation<double> entrance;
  final Animation<double> pointsProgress;

  @override
  Widget build(BuildContext context) {
    final ringOffset = Directionality.of(context) == TextDirection.ltr
        ? 12.0
        : -12.0;
    return ColoredBox(
      color: AppTheme.productCardSurface,
      child: ClipRect(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24, 32, 0, 32),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                flex: 4,
                child: RewardsTierLadder(member: member, entrance: entrance),
              ),
              Expanded(
                flex: 6,
                child: Transform.translate(
                  // Let the ring crop slightly at the edge like the mockup.
                  offset: Offset(ringOffset, 0),
                  child: RewardsPointsRing(
                    points: member.points,
                    tierProgress: member.tierProgress,
                    progress: pointsProgress,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
