import 'package:client/api/User/user_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ChangePassword extends ConsumerWidget {
  ChangePassword({super.key});

  final passwordProvider = StateProvider<String>((ref) => '');
  final newPasswordProvider = StateProvider<String>((ref) => '');
  final checkNewPasswordProvider = StateProvider<String>((ref) => '');
  final obscureProvider = StateProvider<bool>((ref) => true);
  final obscureNewProvider = StateProvider<bool>((ref) => true);
  final obscureCheckNewProvider = StateProvider<bool>((ref) => true);
  final isPasswordFocusedProvider = StateProvider<bool>((ref) => false);
  final isNewPasswordFocusedProvider = StateProvider<bool>((ref) => false);
  final isCheckNewPasswordFocusedProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(passwordProvider);
    final newPassword = ref.watch(newPasswordProvider);
    final checkNewPassword = ref.watch(checkNewPasswordProvider);
    final isAllValidProvider = Provider<bool>((ref) {
      return password.isNotEmpty &&
          newPassword.isNotEmpty &&
          checkNewPassword.isNotEmpty &&
          newPassword == checkNewPassword;
    });
    final isAllValid = ref.watch(isAllValidProvider);

    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.white,
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "비밀번호 변경", color: CareConnectColor.black),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  color: CareConnectColor.black,
                ),
              ),
              SizedBox(width: 8),
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.black),
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: CareConnectColor.neutral[200]!, width: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PasswordTextField(ref),
              SizedBox(height: 27),
              NewPasswordTextField(ref),
              SizedBox(height: 27),
              CheckNewPasswordTextField(ref),
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () async {
          try {
            await ref
                .read(userViewModelProvider.notifier)
                .getChangePassword(password, newPassword);

            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')));
              context.pop();
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(e.toString())));
            }
          }
        },
        child: Container(
          width: double.maxFinite,
          color: CareConnectColor.white,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color:
                  isAllValid
                      ? CareConnectColor.primary[900]
                      : CareConnectColor.neutral[100],
            ),
            child: Center(
              child: Semibold_24px(
                text: "확인",
                color:
                    isAllValid
                        ? CareConnectColor.white
                        : CareConnectColor.neutral[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget PasswordTextField(WidgetRef ref) {
    final isObscure = ref.watch(obscureProvider);
    final isFocused = ref.watch(isPasswordFocusedProvider);
    final password = ref.watch(passwordProvider); // 입력된 비밀번호 값

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '현재 비밀번호'),
        SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            ref.read(isPasswordFocusedProvider.notifier).state = hasFocus;
          },
          child: TextFormField(
            onChanged:
                (value) => ref.read(passwordProvider.notifier).state = value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.black,
            ),
            obscureText: isObscure,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: CareConnectColor.neutral[100],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: CareConnectColor.black),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: "현재 비밀번호를 입력해 주세요",
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CareConnectColor.neutral[400],
              ),

              // ✅ focused거나 password가 비어있지 않으면 eye 아이콘 보이기
              suffixIcon:
                  (isFocused || password.isNotEmpty)
                      ? IconButton(
                        onPressed: () {
                          ref.read(obscureProvider.notifier).state =
                              !ref.read(obscureProvider);
                        },
                        icon: SvgPicture.asset(
                          isObscure
                              ? "assets/icons/eye-slash.svg"
                              : "assets/icons/eye-open.svg",
                          color: CareConnectColor.black,
                        ),
                      )
                      : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 19,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget NewPasswordTextField(WidgetRef ref) {
    final isObscure = ref.watch(obscureNewProvider);
    final isFocused = ref.watch(isNewPasswordFocusedProvider);
    final newPassword = ref.watch(newPasswordProvider); // 입력된 비밀번호 값

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '새 비밀번호'),
        SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            ref.read(isNewPasswordFocusedProvider.notifier).state = hasFocus;
          },
          child: TextFormField(
            onChanged:
                (value) => ref.read(newPasswordProvider.notifier).state = value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.black,
            ),
            obscureText: isObscure,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: CareConnectColor.neutral[100],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: CareConnectColor.black),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: "새 비밀번호를 입력해 주세요",
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CareConnectColor.neutral[400],
              ),

              // ✅ focused거나 password가 비어있지 않으면 eye 아이콘 보이기
              suffixIcon:
                  (isFocused || newPassword.isNotEmpty)
                      ? IconButton(
                        onPressed: () {
                          ref.read(obscureNewProvider.notifier).state =
                              !ref.read(obscureNewProvider);
                        },
                        icon: SvgPicture.asset(
                          isObscure
                              ? "assets/icons/eye-slash.svg"
                              : "assets/icons/eye-open.svg",
                          color: CareConnectColor.black,
                        ),
                      )
                      : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 19,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CheckNewPasswordTextField(WidgetRef ref) {
    final isObscure = ref.watch(obscureCheckNewProvider);
    final isFocused = ref.watch(isCheckNewPasswordFocusedProvider);
    final checkNewPassword = ref.watch(checkNewPasswordProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '새 비밀번호 재입력'),
        SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            ref.read(isCheckNewPasswordFocusedProvider.notifier).state =
                hasFocus;
          },
          child: TextFormField(
            onChanged:
                (value) =>
                    ref.read(checkNewPasswordProvider.notifier).state = value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.black,
            ),
            obscureText: isObscure,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: CareConnectColor.neutral[100],
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: CareConnectColor.black),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: "새 비밀번호를 한번 더 입력해 주세요",
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CareConnectColor.neutral[400],
              ),

              // 👇 focused 상태 또는 값이 있을 때만 아이콘 보이게
              suffixIcon:
                  (isFocused || checkNewPassword.isNotEmpty)
                      ? IconButton(
                        onPressed: () {
                          ref.read(obscureCheckNewProvider.notifier).state =
                              !ref.read(obscureCheckNewProvider);
                        },
                        icon: SvgPicture.asset(
                          isObscure
                              ? "assets/icons/eye-slash.svg"
                              : "assets/icons/eye-open.svg",
                          color: CareConnectColor.black,
                        ),
                      )
                      : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 19,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
