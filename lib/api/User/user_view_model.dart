import 'dart:io';

import 'package:client/api/User/user_repository.dart';
import 'package:client/model/singUp.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:client/screens/signUp/enroll_info/view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());
final profileImageFileProvider = StateProvider<File?>((ref) => null);

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

  /// 피보호자-보호자 연결
  Future<bool> linkfamily(String guardianUsername, String guardianName) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.linkfamily(guardianUsername, guardianName);
      return true;
    } catch (e, st) {
      print('❌ 연결 실패: $e');
      return false;
    }
  }

  /// 피보호자 목록 조회
  Future<void> getDependents() async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final dependents = await repo.getDependentList();
      final names = dependents.map((e) => e.name).toList(); // 이름만 반환
      ref.read(dependentNamesProvider.notifier).state = names;
      final dependentIds = dependents.map((e) => e.dependentId).toList(); // id
      ref.read(dependentIdListProvider.notifier).state = dependentIds;
    } catch (e) {
      print('❌ 에러: $e');
    }
  }

  Future<bool> checkUsername(String username) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final check = await repo.checkUsername(username);
      ref.read(idCheckResultProvider.notifier).state = check;
      return true;
    } catch (e) {
      print('연결 실패: $e');
      return false;
    }
  }

  Future<void> getMine() async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final myInfo = await repo.getMine();
      ref.read(userNameProvider.notifier).state = myInfo['name'];
      ref.read(userTypeProvider.notifier).state = myInfo['userType'];
    } catch (e) {
      print('연결 실패: $e');
    }
  }

  Future<void> getChangePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      await repo.getChangePassword(currentPassword, newPassword);
    } catch (e) {
      print('연결 실패: $e');
    }
  }
}
