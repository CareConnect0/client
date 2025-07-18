import 'package:client/api/User/user_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/singUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

final typeProvider = StateProvider<List<bool>>((ref) => [false, false]);
final idProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');
final checkPasswordProvider = StateProvider<String>((ref) => '');
final obscureProvider = StateProvider<bool>((ref) => true);
final obscureCheckProvider = StateProvider<bool>((ref) => true);
final isPasswordFocusedProvider = StateProvider<bool>((ref) => false);
final isCheckPasswordFocusedProvider = StateProvider<bool>((ref) => false);
final idCheckResultProvider = StateProvider<bool?>((ref) => null);

bool isPasswordValid(String password) {
  final lengthValid = password.length >= 8 && password.length <= 15;
  final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
  final hasNumber = RegExp(r'\d').hasMatch(password);
  final hasSpecial = RegExp(r'[!@#\$&*~%^(),.?":{}|<>]').hasMatch(password);

  return lengthValid && hasLetter && hasNumber && hasSpecial;
}

bool isIdValid(String id) {
  final lengthValid = id.length >= 8 && id.length <= 15;
  final hasOnlyLettersAndNumbers = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(id);
  return lengthValid && hasOnlyLettersAndNumbers;
}

class EnrollInfo extends ConsumerWidget {
  EnrollInfo({super.key});

  final PageController controller = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(typeProvider); // 현재 상태
    final typeNotifier = ref.read(typeProvider.notifier); // 상태 변경용
    final id = ref.watch(idProvider);
    final password = ref.watch(passwordProvider);
    final checkPassword = ref.watch(checkPasswordProvider);
    final idCheckResult = ref.watch(idCheckResultProvider);

    final isAllValidProvider = Provider<bool>((ref) {
      return id.isNotEmpty &&
          isIdValid(id) &&
          password.isNotEmpty &&
          isPasswordValid(password) &&
          checkPassword.isNotEmpty &&
          password == checkPassword &&
          (idCheckResult == true) &&
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
                          color:
                              type[0]
                                  ? CareConnectColor.primary[900]
                                  : CareConnectColor.neutral[100],
                        ),
                        child: Center(
                          child: Bold_22px(
                            text: '피보호자',
                            color:
                                type[0]
                                    ? CareConnectColor.white
                                    : CareConnectColor.neutral[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 28),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        typeNotifier.state = [false, true];
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 56.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              type[1]
                                  ? CareConnectColor.primary[900]
                                  : CareConnectColor.neutral[100],
                        ),
                        child: Center(
                          child: Bold_22px(
                            text: '보호자',
                            color:
                                type[1]
                                    ? CareConnectColor.white
                                    : CareConnectColor.neutral[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 31),
              IdTextField(ref, context),
              SizedBox(height: 27),
              PasswordTextField(ref),
              SizedBox(height: 27),
              CheckPasswordTextField(ref),
              SizedBox(height: 46),
              PageIndicator(),
              SizedBox(height: 39),
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap:
            isAllValid
                ? () {
                  final userType = type[0] ? 'DEPENDENT' : 'GUARDIAN';

                  final signupData = SignupData(
                    username: id,
                    password: password,
                    userType: userType,
                  );

                  type[0]
                      ? context.go(
                        '/signUp/checkVerification',
                        extra: signupData,
                      )
                      : context.go('/signUp/idVerification', extra: signupData);
                }
                : null,
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
                text: "다음",
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

  Widget IdTextField(WidgetRef ref, BuildContext context) {
    final idCheckResult = ref.watch(idCheckResultProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '아이디'),
        SizedBox(height: 6),
        TextFormField(
          onChanged: (value) {
            ref.read(idProvider.notifier).state = value;
            ref.read(idCheckResultProvider.notifier).state = null;
          },
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CareConnectColor.black,
          ),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  idCheckResult != null
                      ? (idCheckResult
                          ? BorderSide.none
                          : BorderSide(color: const Color(0xFFF63D68)))
                      : BorderSide.none,
            ),
            filled: true,
            fillColor:
                idCheckResult != null
                    ? (idCheckResult
                        ? CareConnectColor.neutral[100]
                        : const Color(0xFFFFF1F3))
                    : CareConnectColor.neutral[100],
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
            suffixIcon: InkWell(
              onTap: () async {
                final id = ref.read(idProvider);
                if (isIdValid(id)) {
                  await ref
                      .read(userViewModelProvider.notifier)
                      .checkUsername(id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('8~15자 사이로 입력해주세요.'),
                      backgroundColor: CareConnectColor.black.withOpacity(0.5),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                child: Container(
                  width: 71,
                  height: 34,
                  decoration: BoxDecoration(
                    color: CareConnectColor.neutral[700],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Medium_12px(
                      text: '중복 확인',
                      color: CareConnectColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Medium_14px(
                text: "아이디는 8~15자의 영문자 또는 숫자만 사용할 수 있어요.",
                color: CareConnectColor.neutral[400],
              ),
            ],
          ),
        ),
        if (idCheckResult != null)
          Column(
            children: [
              const SizedBox(height: 8),
              Medium_14px(
                text: idCheckResult ? '사용할 수 있는 아이디입니다.' : '중복된 아이디입니다.',
                color: CareConnectColor.neutral[400],
              ),
            ],
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
            onChanged:
                (value) => ref.read(passwordProvider.notifier).state = value,
            onTap:
                () => ref.read(isPasswordFocusedProvider.notifier).state = true,
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
        if (isFocused)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Medium_14px(
                  text: "비밀번호는 8~15자, 영어/숫자/특수기호를 포함해야 해요.",
                  color: CareConnectColor.neutral[400],
                ),
              ],
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
            onChanged:
                (value) =>
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
              suffixIcon:
                  (isFocused || checkPassword.isNotEmpty)
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
