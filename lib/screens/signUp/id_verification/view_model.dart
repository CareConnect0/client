import 'package:client/model/singUp.dart';
import 'package:client/screens/signUp/id_verification/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = Provider<AuthViewModel>(
  (ref) => AuthViewModel(AuthRepository()),
);

class AuthViewModel {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  Future<void> signUpWithFullData(SignupData data) async {
    await _authRepository.signup(data);
  }
}
