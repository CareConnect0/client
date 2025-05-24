import 'dart:async';

import 'package:client/api/Auth/auth_view_model.dart';
import 'package:client/api/User/user_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/singUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CheckVerification extends ConsumerWidget {
  final SignupData signupData;
  CheckVerification({super.key, required this.signupData});

  final nameProvider = StateProvider<String>((ref) => '');
  final numberProvider = StateProvider<String>((ref) => '');
  final checkNumberProvider = StateProvider<String>((ref) => '');
  final isButtonVisibleProvider = StateProvider<bool>((ref) => true);
  final isVerificationSuccessProvider = StateProvider<bool>((ref) => false);
  Timer? timer;
  final timerProvider = StateProvider<int>((ref) => 300); // 5분

  final PageController controller = PageController(initialPage: 2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllValidProvider = Provider<bool>((ref) {
      final name = ref.watch(nameProvider);
      final number = ref.watch(numberProvider);
      final checkNumber = ref.watch(checkNumberProvider);
      final verification = ref.watch(isVerificationSuccessProvider);
      return name.isNotEmpty &&
          number.isNotEmpty &&
          checkNumber.isNotEmpty &&
          verification == true;
    });
    final isAllValid = ref.watch(isAllValidProvider);
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bold_24px(text: "피보호자 인증"),
                    SizedBox(height: 11),
                    Medium_16px(text: "피보호자 인증을 위해 필요한 정보를 입력해 주세요."),
                    SizedBox(height: 40),
                    nameTextField(ref),
                    SizedBox(height: 24),
                    numberTextField(ref, context),
                    SizedBox(height: 8),
                    checkNumberTextField(ref),
                    SizedBox(height: 32),
                  ],
                ),
                Column(children: [PageIndicator(), SizedBox(height: 39)]),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap:
            isAllValid
                ? () async {
                  final updatedData = signupData.copyWith(
                    name: ref.read(nameProvider),
                    phoneNumber: ref.read(numberProvider),
                  );
                  await ref
                      .read(userViewModelProvider.notifier)
                      .signUpWithFullData(updatedData);
                  await ref
                      .read(authViewModelProvider.notifier)
                      .login(signupData.username, signupData.password);
                  context.go('/signUp/checkVerification/connect');
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

  Widget nameTextField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '이름'),
        SizedBox(height: 6),
        TextFormField(
          onChanged: (value) => ref.read(nameProvider.notifier).state = value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CareConnectColor.black,
          ),
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
            labelText: "이름을 입력해 주세요",
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

  Widget numberTextField(WidgetRef ref, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '휴대전화 인증'),
        SizedBox(height: 6),
        TextFormField(
          onChanged: (value) => ref.read(numberProvider.notifier).state = value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CareConnectColor.black,
          ),
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CareConnectColor.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CareConnectColor.black),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: "휴대전화 번호 입력",
            labelStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CareConnectColor.neutral[400],
            ),
            suffixIcon: Consumer(
              builder: (context, ref, _) {
                final isVisible = ref.watch(isButtonVisibleProvider);

                if (!isVisible) return SizedBox.shrink(); // 안 보이게

                return InkWell(
                  onTap: () {
                    startTimer(ref, context);
                    final viewModel = ref.read(authViewModelProvider.notifier);
                    viewModel.sendPhoneVerificationCode(
                      ref.read(numberProvider),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 15, left: 8),
                    width: 73,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CareConnectColor.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(90),
                    ),
                    child: Center(child: Medium_16px(text: '인증요청')),
                  ),
                );
              },
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget checkNumberTextField(WidgetRef ref) {
    final remain = ref.watch(timerProvider);
    final minutes = (remain ~/ 60).toString().padLeft(2, '0');
    final seconds = (remain % 60).toString().padLeft(2, '0');
    return TextFormField(
      onChanged:
          (value) => ref.read(checkNumberProvider.notifier).state = value,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: CareConnectColor.black,
      ),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CareConnectColor.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CareConnectColor.black),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelText: "인증 번호 입력",
        labelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: CareConnectColor.neutral[400],
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Medium_16px(text: '$minutes:$seconds', color: Colors.lightBlue),
              SizedBox(width: 4),
              Consumer(
                builder: (context, ref, _) {
                  final isVerified = ref.watch(isVerificationSuccessProvider);
                  if (isVerified) {
                    return Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 24,
                    );
                  } else {
                    return InkWell(
                      onTap: () async {
                        final viewModel = ref.read(
                          authViewModelProvider.notifier,
                        );
                        try {
                          await viewModel.verifyPhoneVerificationCode(
                            ref.read(numberProvider),
                            ref.read(checkNumberProvider),
                          );
                          ref
                              .read(isVerificationSuccessProvider.notifier)
                              .state = true;
                        } catch (_) {
                          ref
                              .read(isVerificationSuccessProvider.notifier)
                              .state = false;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('인증번호가 올바르지 않습니다.'),
                              backgroundColor: CareConnectColor.black
                                  .withOpacity(0.5),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 73,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CareConnectColor.black,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(90),
                        ),
                        child: Center(child: Medium_16px(text: '확인')),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  void startTimer(WidgetRef ref, BuildContext context) {
    timer?.cancel(); // 기존 타이머 중복 방지
    ref.read(timerProvider.notifier).state = 300;
    ref.read(isButtonVisibleProvider.notifier).state = false; // 버튼 숨기기

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (!context.mounted) {
        t.cancel();
        return;
      }

      final remain = ref.read(timerProvider);
      if (remain <= 1) {
        t.cancel();
        ref.read(isButtonVisibleProvider.notifier).state =
            true; // 5분 지나면 버튼 다시 보이게

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 34, horizontal: 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Medium_18px(text: "인증 요청 시간이 초과되었습니다."),
                    Medium_18px(text: "재인증 후 시도해주세요."),
                    SizedBox(height: 33),
                    InkWell(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CareConnectColor.neutral[600],
                        ),
                        child: Center(
                          child: Semibold_16px(
                            text: "확인",
                            color: CareConnectColor.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      ref.read(timerProvider.notifier).state--;
    });
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
