import 'package:client/api/User/user_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ConnectFamily extends ConsumerWidget {
  ConnectFamily({super.key});

  final familyNameProvider = StateProvider<String>((ref) => '');
  final familyIdProvider = StateProvider<String>((ref) => '');

  final PageController controller = PageController(initialPage: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllValidProvider = Provider<bool>((ref) {
      final familyName = ref.watch(familyNameProvider);
      final familyId = ref.watch(familyIdProvider);
      return familyName.isNotEmpty && familyId.isNotEmpty;
    });
    final isAllValid = ref.watch(isAllValidProvider);

    return Scaffold(
      backgroundColor: CareConnectColor.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bold_24px(text: "보호자 연결"),
            SizedBox(height: 11),
            Medium_16px(text: "보호자 연결을 위해 필요한 정보를 입력해 주세요."),
            SizedBox(height: 40),
            familyField(ref, context),
            SizedBox(
              height: 32,
            ),
            Spacer(),
            PageIndicator(),
            SizedBox(
              height: 39,
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: isAllValid
            ? () async {
                final viewModel = ref.read(userViewModelProvider.notifier);
                final guardianUsername = ref.watch(familyIdProvider);
                final guardianName = ref.watch(familyNameProvider);
                print('$guardianUsername, $guardianName');

                final isSuccess =
                    await viewModel.linkfamily(guardianUsername, guardianName);

                if (isSuccess) {
                  context.go('/signUp/congratulation');
                } else {
                  // 실패했을 경우 스낵바 등 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('연결에 실패했습니다. 다시 시도해주세요.')),
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

  Widget familyField(WidgetRef ref, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semibold_20px(text: '보호자 인증'),
        SizedBox(
          height: 6,
        ),
        TextFormField(
          onChanged: (value) =>
              ref.read(familyNameProvider.notifier).state = value,
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
        SizedBox(
          height: 8,
        ),
        TextFormField(
          onChanged: (value) =>
              ref.read(familyIdProvider.notifier).state = value,
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
