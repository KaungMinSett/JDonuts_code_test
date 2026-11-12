typedef MemberProfile = ({
  String id,
  String name,
  String imageAsset,
  String tier,
  int tierStartPoints,
  int points,
  String nextTier,
  int nextTierPoints,
  int notificationCount,
});

extension MemberTierProgress on MemberProfile {
  double get tierProgress {
    // Measure the points earned since entering the current tier.
    final tierRange = nextTierPoints - tierStartPoints;
    if (tierRange <= 0) return 0;
    return ((points - tierStartPoints) / tierRange).clamp(0.0, 1.0);
  }
}
