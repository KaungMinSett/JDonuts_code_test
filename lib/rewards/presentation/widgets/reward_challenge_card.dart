import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import '../../../core/widgets/catalog_image.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../l10n/app_localizations.dart';
import '../../domain/rewards_repository.dart';

class RewardChallengeCard extends StatelessWidget {
  const RewardChallengeCard({super.key, required this.challenge});

  final RewardChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final imageAsset = challenge.imageAsset;
    final isComplete = challenge.completed == challenge.target;
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
              child: AspectRatio(
                aspectRatio: 1,
                child: imageAsset == null
                    ? Icon(
                        Icons.local_cafe_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 48,
                      )
                    : CatalogImage(assetPath: imageAsset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppTheme.homeSectionTitleSpacing,
                children: [
                  Text(challenge.title, style: theme.textTheme.titleMedium),
                  Text(
                    l10n.rewardsChallengeProgress(
                      challenge.completed,
                      challenge.target,
                    ),
                  ),
                  Text(l10n.rewardsChallengePoints(challenge.rewardPoints)),
                  PrimaryButton(
                    label: l10n.rewardsEarn,
                    // Earn has press feedback only, as specified in the brief.
                    onPressed: isComplete ? () {} : null,
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
