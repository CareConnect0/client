import 'package:client/api/User/user_repository.dart';
import 'package:client/model/singUp.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<void>>(
  (ref) => UserViewModel(ref),
);

class UserViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UserViewModel(this.ref) : super(const AsyncData(null));

  // 회원가입 로직
  Future<void> signUpWithFullData(SignupData data) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.signup(data);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  // 회원탈퇴
  Future<void> withdrawal(String password) async {
    state = const AsyncLoading();

    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.withdraw(password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
