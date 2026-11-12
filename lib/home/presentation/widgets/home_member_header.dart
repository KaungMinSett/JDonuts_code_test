import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/domain/member_profile.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../core/widgets/count_badge.dart';
import '../../../core/widgets/pill_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../home_providers.dart';
import 'home_section_state.dart';

class HomeMemberHeader extends ConsumerWidget {
  const HomeMemberHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 18),
      child: HomeSectionState(
        state: ref.watch(memberProfileProvider),
        onRetry: () => ref.invalidate(memberProfileProvider),
        builder: (member) => member == null
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.homeHeaderGutter,
                ),
                child: Text(l10n.homeMemberEmpty),
              )
            : _MemberHeaderContent(member: member),
      ),
    );
  }
}

class _MemberHeaderContent extends StatelessWidget {
  const _MemberHeaderContent({required this.member});

  final MemberProfile member;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final pointsToTier = member.nextTierPoints - member.points;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppTheme.homeHeaderGutter,
          ),
          child: Row(
            children: [
              Expanded(
                child: MemberInfo(
                  avatarAsset: member.imageAsset,
                  name: member.name,
                  tier: l10n.homeMemberTier(member.tier),
                ),
              ),
              const SizedBox(width: 12),
              Semantics(
                label: l10n.homeNotificationCount(member.notificationCount),
                excludeSemantics: true,
                child: CountBadge(
                  count: member.notificationCount,
                  child: const Icon(Icons.notifications_outlined),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.homeHeaderGutter,
            12,
            AppTheme.homeHeaderGutter,
            0,
          ),
          child: PillBadge(
            label: l10n.homePointsToTier(pointsToTier, member.nextTier),
            backgroundColor: colors.surface,
            foregroundColor: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

class MemberInfo extends StatelessWidget {
  const MemberInfo({
    super.key,
    required this.avatarAsset,
    required this.name,
    required this.tier,
  });

  final String avatarAsset;
  final String name;
  final String tier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        ClipOval(
          child: SizedBox.square(
            dimension: 56,
            child: CatalogImage(assetPath: avatarAsset),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(tier, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
