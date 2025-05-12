import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/Auth/auth_repository.dart';
import 'package:client/model/singUp.dart';

// Repository Provider
final authRepositoryProvider = Provider((ref) => AuthRepository());

// ViewModel Provider (StateNotifier로 관리)
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<void>>(
  (ref) => AuthViewModel(ref),
);

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AuthViewModel(this.ref) : super(const AsyncData(null));

  // 로그인 로직
  Future<void> login(String username, String password) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);
      final tokens = await repo.login(username, password);

      print('AccessToken: ${tokens['accessToken']}');
      print('RefreshToken: ${tokens['refreshToken']}');

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // 회원가입 로직
  Future<void> signUpWithFullData(SignupData data) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signup(data);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
