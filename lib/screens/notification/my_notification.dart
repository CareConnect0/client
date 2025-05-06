import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MyNotification extends ConsumerWidget {
  MyNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.white,
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(
          text: "알림 확인",
          color: CareConnectColor.black,
        ),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  color: CareConnectColor.neutral[700],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Semibold_16px(
                text: "뒤로가기",
                color: CareConnectColor.neutral[700],
              )
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: CareConnectColor.neutral[200]!,
            width: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Text(
                  "24시간이 지난 알림은 자동으로 삭제됩니다.",
                  style: TextStyle(
                    color: CareConnectColor.neutral[300],
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  "모두 삭제",
                  style: TextStyle(
                    color: CareConnectColor.neutral[400],
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // 👈 스크롤 가능한 리스트 만들기
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return NotificationCard(CareConnectColor.secondary[200]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget NotificationCard(color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CareConnectColor.black.withOpacity(0.25),
            blurRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
        color: color,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semibold_18px(text: "00님이\n[]일정을 등록했습니다!"),
              SizedBox(
                height: 16,
              ),
              Medium_16px(
                text: "2025.03.01",
                color: CareConnectColor.neutral[600],
              ),
            ],
          ),
          Spacer(),
          SvgPicture.asset("assets/icons/x-close.svg"),
        ],
      ),
    );
  }
}
