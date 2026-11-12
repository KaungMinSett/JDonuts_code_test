import 'package:flutter/material.dart';

import '../../app/config/app_theme.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/sign_out_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.catalogBackground,
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsTitle)),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: AppTheme.catalogContentPadding,
          children: const [SignOutButton()],
        ),
      ),
    );
  }
}
