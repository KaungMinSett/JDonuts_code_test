import 'package:flutter/material.dart';

import '../../../app/config/app_theme.dart';
import 'home_banner_carousel.dart';
import 'home_member_header.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Paint through the carousel so the two parts read as one section.
    return const ClipRRect(
      borderRadius: AppTheme.homeHeaderRadius,
      child: ColoredBox(
        color: AppTheme.homeHeaderBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [HomeMemberHeader(), HomeBannerCarousel()],
        ),
      ),
    );
  }
}
