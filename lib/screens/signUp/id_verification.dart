import 'dart:async';

import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IdVerification extends ConsumerWidget {
  IdVerification({super.key});

  final nameProvider = StateProvider<String>((ref) => '');
  final numberProvider = StateProvider<String>((ref) => '');
  final checkNumberProvider = StateProvider<String>((ref) => '');

  final PageController controller = PageController(initialPage: 2);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllValidProvider = Provider<bool>((ref) {
      final name = ref.watch(nameProvider);
      final number = ref.watch(numberProvider);
      final checkNumber = ref.watch(checkNumberProvider);
      return name.isNotEmpty &&
          number.isNotEmpty &&
          checkNumber.isNotEmpty; // 추후 인증번호와 확인하는 로직 추가
    });
    final isAllValid = ref.watch(isAllValidProvider);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bold_24px(text: "본인 인증"),
            SizedBox(height: 11),
            Medium_16px(text: "본인인증을 위해 필요한 정보를 입력해 주세요."),
            SizedBox(height: 40),
            nameTextField(ref),
            Spacer(),
            numberTextField(ref),
            SizedBox(
              height: 11,
            ),
            checkNumberTextField(ref),
            SizedBox(
              height: 32,
            ),
            PageIndicator(),
            SizedBox(
              height: 39,
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: isAllValid
            ? () {
                context.go('/SignIn');
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

  Widget nameTextField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '이름'),
        SizedBox(
          height: 6,
        ),
        TextFormField(
          onChanged: (value) => ref.read(nameProvider.notifier).state = value,
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

  Widget numberTextField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '휴대전화 인증'),
        SizedBox(
          height: 6,
        ),
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
            suffixIcon: GestureDetector(
              onTap: () {
                startTimer(ref);
              },
              child: Container(
                margin: EdgeInsets.only(top: 15, left: 8),
                width: 73,
                decoration: BoxDecoration(
                  border: Border.all(color: CareConnectColor.black, width: 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(child: Medium_16px(text: '인증요청')),
              ),
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
      onChanged: (value) =>
          ref.read(checkNumberProvider.notifier).state = value,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Medium_16px(
                text: '$minutes:$seconds',
                color: Colors.lightBlue,
              ),
              SizedBox(
                width: 4,
              ),
              Container(
                width: 73,
                decoration: BoxDecoration(
                  border: Border.all(color: CareConnectColor.black, width: 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(child: Medium_16px(text: '확인')),
              ),
            ],
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Timer? timer;
  final timerProvider = StateProvider<int>((ref) => 300); // 5분
  void startTimer(WidgetRef ref) {
    timer?.cancel(); // 기존 타이머 중복 방지
    ref.read(timerProvider.notifier).state = 300;

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      final remain = ref.read(timerProvider);
      if (remain <= 1) {
        t.cancel();
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
          count: 3,
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
