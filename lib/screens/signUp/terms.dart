import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// 다중 체크 상태 관리
final termsCheckedProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    for (var term in termsList) term['title'] as String: false,
  };
});

final termsList = [
  {'title': '서비스 이용약관', 'required': true},
  {'title': '개인정보 수집 및 이용 동의', 'required': true},
  {'title': '위치기반 서비스 이용약관', 'required': true},
  {'title': '마케팅 수신 동의', 'required': false},
];

final isAllRequiredCheckedProvider = Provider<bool>((ref) {
  final checkedMap = ref.watch(termsCheckedProvider);
  return termsList
      .where((term) => term['required'] == true)
      .every((term) => checkedMap[term['title']] == true);
});

final isEveryTermCheckedProvider = Provider<bool>((ref) {
  final checkedMap = ref.watch(termsCheckedProvider);
  return checkedMap.values.every((checked) => checked == true);
});

final PageController controller = PageController(initialPage: 0);

class Terms extends ConsumerWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkedMap = ref.watch(termsCheckedProvider);

    final isAllChecked = ref.watch(isAllRequiredCheckedProvider);

    final isEveryTermChecked = ref.watch(isEveryTermCheckedProvider);

    void checkAllTerms(WidgetRef ref) {
      final allChecked = {
        for (var term in termsList) term['title'] as String: true,
      };
      ref.read(termsCheckedProvider.notifier).state = allChecked;
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bold_24px(text: "약관동의"),
            SizedBox(height: 11),
            Medium_16px(text: "필수항목 및 선택항목 약관에 동의해 주세요."),
            SizedBox(height: 18),
            // 전체동의
            InkWell(
              onTap: () {
                checkAllTerms(ref);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isEveryTermChecked
                      ? CareConnectColor.primary[900]
                      : CareConnectColor.neutral[100],
                ),
                child: Center(
                  child: Semibold_20px(
                    text: "전체동의",
                    color: isEveryTermChecked
                        ? CareConnectColor.white
                        : CareConnectColor.neutral[400],
                  ),
                ),
              ),
            ),
            SizedBox(height: 41),

            //  약관 목록 반복 생성
            for (var term in termsList) ...[
              condition(
                term['title'].toString(),
                term['required'] == true ? '필수' : '선택',
                ref,
              ),
              SizedBox(height: 30),
            ],
            Spacer(),
            PageIndicator(),
            SizedBox(
              height: 39,
            ),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          if (isAllChecked) {
            context.go('/signUp/enrollInfo');
          }
        },
        child: Container(
          width: double.maxFinite,
          color: CareConnectColor.white,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: isAllChecked
                  ? CareConnectColor.primary[900]
                  : CareConnectColor.neutral[100],
            ),
            child: Center(
              child: Semibold_24px(
                text: "다음",
                color: isAllChecked
                    ? CareConnectColor.white
                    : CareConnectColor.neutral[400],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget condition(String title, String filter, WidgetRef ref) {
    final checkedMap = ref.watch(termsCheckedProvider);
    final isChecked = checkedMap[title] ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            ref.read(termsCheckedProvider.notifier).update((state) {
              return {
                ...state,
                title: !isChecked,
              };
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isChecked
                  ? CareConnectColor.primary[900]!
                  : CareConnectColor.neutral[200]!,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.check,
              size: 18,
              color: CareConnectColor.white,
            ),
          ),
        ),
        SizedBox(width: 18),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.5, horizontal: 7.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            border: Border.all(color: CareConnectColor.black, width: 1),
          ),
          child: Medium_16px(
            text: filter,
            color: CareConnectColor.black,
          ),
        ),
        SizedBox(width: 11),
        Medium_16px(text: title),
        Spacer(),
        SvgPicture.asset("assets/icons/chevron-right.svg"),
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
