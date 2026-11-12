import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../config/app_motion.dart';
import '../config/app_theme.dart';

enum _Destination {
  home(Icons.home_outlined, '/home'),
  rewards(Icons.emoji_events_outlined, '/rewards'),
  menu(Icons.donut_large, null),
  wallet(Icons.account_balance_wallet_outlined, null),
  settings(Icons.settings_outlined, '/settings');

  const _Destination(this.icon, this.path);

  final IconData icon;
  final String? path;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.homeTitle,
    rewards => l10n.rewardsLabel,
    menu => l10n.mainMenuLabel,
    wallet => l10n.mainWalletLabel,
    settings => l10n.settingsTitle,
  };
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key, required this.location});

  static const _selectedWidthFraction = 0.32;
  static const _pillInset = 2.0;
  static const _pinkStripHeight = 44.0;
  static const _barShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    side: BorderSide(color: AppTheme.productCardSurface),
  );

  final String location;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final selected = _Destination.values.firstWhere(
      (destination) => destination.path == location,
    );
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.mainTabSlideDuration;

    return Stack(
      children: [
        // Anchor the pink strip to the same bottom edge as the cyan panel.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: _pinkStripHeight,
          child: ColoredBox(color: colors.secondary),
        ),
        SafeArea(
          top: false,
          // Keep the side gutters without lifting the panel off the bottom.
          bottom: false,
          minimum: const EdgeInsets.symmetric(horizontal: 12),
          child: Material(
            color: colors.primary,
            shape: _barShape,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: SizedBox(
                height: 48,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final selectedWidth =
                        constraints.maxWidth * _selectedWidthFraction;
                    final iconWidth =
                        (constraints.maxWidth - selectedWidth) /
                        (_Destination.values.length - 1);
                    // Reserve extra space for the selected destination's label.
                    double startOf(_Destination destination) =>
                        iconWidth * destination.index +
                        (destination.index > selected.index
                            ? selectedWidth - iconWidth
                            : 0);

                    return Stack(
                      children: [
                        AnimatedPositionedDirectional(
                          duration: duration,
                          curve: AppMotion.mainTabSlideCurve,
                          start: startOf(selected) + _pillInset,
                          width: selectedWidth - _pillInset * 2,
                          top: 0,
                          bottom: 0,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              color: colors.secondary,
                              shape: const StadiumBorder(
                                side: BorderSide(
                                  color: AppTheme.productCardSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (final destination in _Destination.values)
                          AnimatedPositionedDirectional(
                            key: ValueKey(destination),
                            duration: duration,
                            curve: AppMotion.mainTabSlideCurve,
                            start: startOf(destination),
                            width: destination == selected
                                ? selectedWidth
                                : iconWidth,
                            top: 0,
                            bottom: 0,
                            child: _NavigationButton(
                              icon: destination.icon,
                              label: destination.label(l10n),
                              selected: destination == selected,
                              path: destination.path,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.path,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final String? path;

  @override
  Widget build(BuildContext context) {
    final destination = path;
    final theme = Theme.of(context);
    final foreground = theme.colorScheme.onPrimary;
    return Semantics(
      label: label,
      button: true,
      enabled: destination != null,
      selected: selected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: destination == null
              ? null
              : () {
                  if (!selected) context.go(destination);
                },
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: FittedBox(
                // Fit the label as the destination widens during the slide.
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Icon(icon, size: 22, color: foreground),
                    if (selected)
                      Text(
                        label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
