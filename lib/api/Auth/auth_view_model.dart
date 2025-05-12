import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/api/Auth/auth_repository.dart';

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

  /// 휴대폰 인증번호 전송
  Future<void> sendPhoneVerificationCode(String phoneNumber) async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.sendVerificationCode(phoneNumber);
      print('✅ 인증번호 전송 완료');
    } catch (e) {
      print('❌ 인증번호 전송 실패: $e');
    }
  }

  /// 전화번호 인증번호 확인
  Future<void> verifyPhoneVerificationCode(
      String phoneNumber, String code) async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.verifyPhoneVerificationCode(phoneNumber, code);
      print('✅ 인증번호 확인 완료');
    } catch (e) {
      print('❌ 인증번호 확인 실패: $e');
    }
  }
}
