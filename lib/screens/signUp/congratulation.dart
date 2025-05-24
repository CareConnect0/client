import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Congratulation extends ConsumerWidget {
  Congratulation({super.key});

  final PageController controller = PageController(initialPage: 3);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Image.asset('assets/images/congratulation.png'),
                    SizedBox(height: 36),
                    Bold_26px(text: '만나서 반가워요!'),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Bold_26px(
                          text: '함께하루',
                          color: CareConnectColor.primary[900],
                        ),
                        Bold_26px(text: '에서'),
                      ],
                    ),
                    Bold_26px(text: '따뜻한 온기를 느껴보세요'),
                  ],
                ),
                Column(children: [PageIndicator(), SizedBox(height: 39)]),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () {
          context.go('/SignIn');
        },
        child: Container(
          width: double.maxFinite,
          color: CareConnectColor.white,
          child: Container(
            height: 72,
            decoration: BoxDecoration(color: CareConnectColor.primary[900]),
            child: Center(
              child: Semibold_24px(text: "시작하기", color: CareConnectColor.white),
            ),
          ),
        ),
      ),
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
