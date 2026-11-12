import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/domain/catalog_failure.dart';
import '../../../core/domain/result.dart';
import '../../../core/widgets/catalog_load_error.dart';
import 'home_skeleton.dart';

class HomeSectionState<T> extends StatelessWidget {
  const HomeSectionState({
    super.key,
    required this.state,
    required this.onRetry,
    required this.loading,
    required this.builder,
  });

  final AsyncValue<Result<T, CatalogFailure>> state;
  final VoidCallback onRetry;
  final Widget loading;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) {
    // Keep loading or retry feedback inside the section that needs it.
    return switch (state) {
      AsyncData(value: Success(value: final data)) => builder(data),
      AsyncData(value: Failure()) ||
      AsyncError() => CatalogLoadError(onRetry: onRetry),
      _ => HomeSkeleton(child: loading),
    };
  }
}
