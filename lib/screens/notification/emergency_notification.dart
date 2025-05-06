import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class EmergencyNotification extends ConsumerWidget {
  const EmergencyNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
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
                    onTap: () {},
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
                    onTap: () {},
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
