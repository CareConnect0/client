import 'package:client/screens/signIn/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>(
  (ref) => AuthViewModel(ref),
);

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref; // Reader → Ref

  AuthViewModel(this.ref) : super(const AsyncData(null));

  Future<void> login(String username, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final tokens = await repo.login(username, password);

    print('AccessToken: ${tokens['accessToken']}');
    print('RefreshToken: ${tokens['refreshToken']}');
  }
}
