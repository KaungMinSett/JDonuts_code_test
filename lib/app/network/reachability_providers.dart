import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'internet_reachability.dart';

const _pollInterval = Duration(seconds: 15);

final internetReachabilityProvider = Provider<InternetReachability>(
  (ref) => InternetReachability(),
);

final isOnlineProvider = StreamProvider.autoDispose<bool>((ref) {
  final reachability = ref.watch(internetReachabilityProvider);
  final onlineStatuses = StreamController<bool>();
  Timer? pollTimer;
  var latestCheck = 0;

  Future<void> checkInternet() async {
    final checkNumber = ++latestCheck;
    final isOnline = await reachability.isOnline();
    // An older probe can finish after the network has changed again.
    if (checkNumber == latestCheck) onlineStatuses.add(isOnline);
  }

  void stopChecking() {
    latestCheck++;
    pollTimer?.cancel();
    pollTimer = null;
  }

  void updateLifecycle(AppLifecycleState state) {
    stopChecking();
    if (state != AppLifecycleState.resumed) return;
    unawaited(checkInternet());
    // Poll while active to catch internet loss on the same Wi-Fi connection.
    pollTimer = Timer.periodic(
      _pollInterval,
      (_) => unawaited(checkInternet()),
    );
  }

  final networkSubscription = reachability.networkChanges.listen(
    (_) {
      if (pollTimer != null) unawaited(checkInternet());
    },
    onError: (Object error, StackTrace stackTrace) {
      // Foreground polling still works if the plugin's event stream fails.
      developer.log(
        'Could not listen for network changes.',
        error: error,
        stackTrace: stackTrace,
      );
    },
  );
  final lifecycle = AppLifecycleListener(onStateChange: updateLifecycle);
  ref.onDispose(() {
    stopChecking();
    lifecycle.dispose();
    unawaited(networkSubscription.cancel());
    unawaited(onlineStatuses.close());
  });

  updateLifecycle(
    WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed,
  );
  return onlineStatuses.stream.distinct();
});
