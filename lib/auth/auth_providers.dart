import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/fake_auth_repository.dart';
import 'domain/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const FakeAuthRepository(), // Dependency injection for the AuthRepository
);
