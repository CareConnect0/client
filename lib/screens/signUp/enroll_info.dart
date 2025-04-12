import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EnrollInfo extends ConsumerWidget {
  EnrollInfo({super.key});

  final typeProvider = StateProvider<List<bool>>((ref) => [false, false]);
  final idProvider = StateProvider<String>((ref) => '');
  final passwordProvider = StateProvider<String>((ref) => '');
  final checkPasswordProvider = StateProvider<String>((ref) => '');
  final obscureProvider = StateProvider<bool>((ref) => true);
  final obscureCheckProvider = StateProvider<bool>((ref) => true);
  final isPasswordFocusedProvider = StateProvider<bool>((ref) => false);
  final isCheckPasswordFocusedProvider = StateProvider<bool>((ref) => false);

  final PageController controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(typeProvider); // 현재 상태
    final typeNotifier = ref.read(typeProvider.notifier); // 상태 변경용

    final isAllValidProvider = Provider<bool>((ref) {
      final id = ref.watch(idProvider);
      final password = ref.watch(passwordProvider);
      final checkPassword = ref.watch(checkPasswordProvider);
      final type = ref.watch(typeProvider);
      return id.isNotEmpty &&
          password.isNotEmpty &&
          checkPassword.isNotEmpty &&
          password == checkPassword &&
          (type[0] == true || type[1] == true);
    });
    final isAllValid = ref.watch(isAllValidProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bold_24px(text: "정보 등록"),
              SizedBox(height: 11),
              Medium_16px(text: "서비스를 위한 정보를 등록해주세요."),
              SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        typeNotifier.state = [true, false];
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 56.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: type[0]
                              ? CareConnectColor.primary[900]
                              : CareConnectColor.neutral[100],
                        ),
                        child: Center(
                          child: Bold_22px(
                            text: '피보호자',
                            color: type[0]
                                ? CareConnectColor.white
                                : CareConnectColor.neutral[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        typeNotifier.state = [false, true];
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 56.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: type[1]
                              ? CareConnectColor.primary[900]
                              : CareConnectColor.neutral[100],
                        ),
                        child: Center(
                          child: Bold_22px(
                            text: '보호자',
                            color: type[1]
                                ? CareConnectColor.white
                                : CareConnectColor.neutral[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 31,
              ),
              IdTextField(ref),
              SizedBox(
                height: 27,
              ),
              PasswordTextField(ref),
              SizedBox(
                height: 27,
              ),
              CheckPasswordTextField(ref),
              SizedBox(
                height: 46,
              ),
              PageIndicator(),
              SizedBox(
                height: 39,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: isAllValid
            ? () {
                type[0]
                    ? context.go('/signUp/checkVerification')
                    : context.go('/signUp/idVerification');
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
                text: "다음",
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
        Semibold_20px(text: '아이디'),
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
        Semibold_20px(text: '비밀번호'),
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

  Widget CheckPasswordTextField(WidgetRef ref) {
    final isObscure = ref.watch(obscureCheckProvider);
    final isFocused = ref.watch(isCheckPasswordFocusedProvider);
    final checkPassword = ref.watch(checkPasswordProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '비밀번호 재입력'),
        SizedBox(height: 6),
        Focus(
          onFocusChange: (hasFocus) {
            ref.read(isCheckPasswordFocusedProvider.notifier).state = hasFocus;
          },
          child: TextFormField(
            onChanged: (value) =>
                ref.read(checkPasswordProvider.notifier).state = value,
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
              labelText: "비밀번호를 한번 더 입력해 주세요",
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CareConnectColor.neutral[400],
              ),

              // 👇 focused 상태 또는 값이 있을 때만 아이콘 보이게
              suffixIcon: (isFocused || checkPassword.isNotEmpty)
                  ? IconButton(
                      onPressed: () {
                        ref.read(obscureCheckProvider.notifier).state =
                            !ref.read(obscureCheckProvider);
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

  Widget PageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SmoothPageIndicator(
          controller: controller,
          count: 4,
          axisDirection: Axis.horizontal,
          effect: ScrollingDotsEffect(
            spacing: 20,
            dotWidth: 12,
            dotHeight: 12,
            dotColor: CareConnectColor.neutral[100]!,
            activeDotColor: CareConnectColor.primary[900]!,
          ),
        ),
      ],
    );
  }
}
