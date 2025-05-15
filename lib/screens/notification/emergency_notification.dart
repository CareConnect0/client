import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNotification extends ConsumerWidget {
  const EmergencyNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              const SizedBox(width: 8),
              Semibold_16px(
                text: "뒤로가기",
                color: CareConnectColor.white,
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          SvgPicture.asset("assets/icons/emergency-notification.svg"),
          SizedBox(
            height: 8,
          ),
          Bold_22px(
            text: "3월 24일\n07시 30분에\n아버지님이 긴급 호출 버튼을\n누르셨습니다.",
            color: CareConnectColor.white,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 36,
          ),
          Bold_20px(
            text: "현재 위치 : OO",
            color: CareConnectColor.white,
          ),
          Bold_20px(
            text: "인식된 음성 : OO",
            color: CareConnectColor.white,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context.push('/emergency/record');
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CareConnectColor.primary[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Bold_26px(
                          text: "녹음듣기",
                          color: CareConnectColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final url = Uri.parse('tel:01012341234');
                      print('tel:01012341234');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CareConnectColor.primary[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Bold_26px(
                          text: "전화하기",
                          color: CareConnectColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
