import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/api/Auth/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});

  final idProvider = StateProvider<String>((ref) => '');
  final passwordProvider = StateProvider<String>((ref) => '');
  final obscureProvider = StateProvider<bool>((ref) => true);
  final isPasswordFocusedProvider = StateProvider<bool>((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllValidProvider = Provider<bool>((ref) {
      final id = ref.watch(idProvider);
      final password = ref.watch(passwordProvider);
      return id.isNotEmpty && password.isNotEmpty;
    });
    final isAllValid = ref.watch(isAllValidProvider);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 50),
        decoration: BoxDecoration(
          image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  CareConnectColor.black.withOpacity(0.65), BlendMode.srcOver),
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                context.go('/');
              },
              child: Container(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
            ),
            Spacer(),
            Bold_26px(
              text: '로그인',
              color: CareConnectColor.white,
            ),
            SizedBox(
              height: 130,
            ),
            IdTextField(ref),
            SizedBox(
              height: 27,
            ),
            PasswordTextField(ref),
            SizedBox(
              height: 16,
            ),
            Medium_16px(
              text: '비밀번호를 잊으셨나요?',
              color: CareConnectColor.white,
            ),
            SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: isAllValid
            ? () async {
                final username = ref.read(idProvider);
                final password = ref.read(passwordProvider);
                final authViewModel = ref.read(authViewModelProvider.notifier);

                await authViewModel.login(username, password);

                final loginState = ref.read(authViewModelProvider);
                if (loginState is AsyncData) {
                  context.go('/home');
                } else if (loginState is AsyncError) {
                  // 에러 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('로그인 실패: ${loginState.error}')),
                  );
                }
              }
            : null,
        child: Container(
          width: double.maxFinite,
          color: CareConnectColor.white,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: isAllValid
                  ? CareConnectColor.primary[900]
                  : CareConnectColor.neutral[100],
            ),
            child: Center(
              child: Semibold_24px(
                text: "로그인",
                color: isAllValid
                    ? CareConnectColor.white
                    : CareConnectColor.neutral[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget IdTextField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(
          text: '아이디',
          color: CareConnectColor.white,
        ),
        SizedBox(
          height: 6,
        ),
        TextFormField(
          onChanged: (value) => ref.read(idProvider.notifier).state = value,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.black),
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
            labelText: "아이디를 입력해 주세요",
            labelStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.neutral[400],
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 19),
          ),
        ),
      ],
    );
  }

  Widget PasswordTextField(WidgetRef ref) {
    final isObscure = ref.watch(obscureProvider);
    final isFocused = ref.watch(isPasswordFocusedProvider);
    final password = ref.watch(passwordProvider); // 입력된 비밀번호 값

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(
          text: '비밀번호',
          color: CareConnectColor.white,
        ),
        SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            ref.read(isPasswordFocusedProvider.notifier).state = hasFocus;
          },
          child: TextFormField(
            onChanged: (value) =>
                ref.read(passwordProvider.notifier).state = value,
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
              labelText: "비밀번호를 입력해 주세요",
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CareConnectColor.neutral[400],
              ),

              // ✅ focused거나 password가 비어있지 않으면 eye 아이콘 보이기
              suffixIcon: (isFocused || password.isNotEmpty)
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

              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
            ),
          ),
        ),
      ],
    );
  }
}
