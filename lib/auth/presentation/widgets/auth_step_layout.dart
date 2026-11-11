import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_theme.dart';
import 'back_button.dart';
import 'doughnut_progress_indicator.dart';

class AuthStepLayout extends StatelessWidget {
  const AuthStepLayout({required this.child, super.key});

  static const _padding = EdgeInsets.fromLTRB(32, 16, 32, 32);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: AppTheme.authStepBackground,
          ),
          child: SafeArea(
            // Keep the footer near the bottom and allow scrolling with the keyboard open.
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(padding: _padding, child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthStepHeader extends StatelessWidget {
  const AuthStepHeader({
    required this.title,
    required this.progress,
    super.key,
  });

  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButton(
              onPressed: () {
                //  honors a step that is completing a session write.
                if (context.canPop()) {
                  Navigator.of(context).maybePop();
                } else {
                  context.go('/');
                }
              },
            ),
            DoughnutProgressIndicator(progress: progress),
          ],
        ),
        const SizedBox(height: 24),
        Text(title, style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}
