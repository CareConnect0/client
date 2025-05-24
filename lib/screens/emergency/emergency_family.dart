import 'package:client/api/emergency/emergency_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/emergencyItem.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EmergencyFamily extends ConsumerWidget {
  EmergencyFamily({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "비상 호출", color: CareConnectColor.white),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset(
                  'assets/icons/chevron-left.svg',
                  color: CareConnectColor.white,
                ),
              ),
              SizedBox(width: 8),
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.white),
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: CareConnectColor.white, width: 1),
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
                    decorationColor: CareConnectColor.neutral[400],
                  ),
                ),
              ],
            ),
          ),
          EmergencyCard(context, ref),
        ],
      ),
    );
  }

  Widget EmergencyCard(BuildContext context, WidgetRef ref) {
    final dependentId = ref.read(dependentSelectedIdProvider);
    return Expanded(
      child: FutureBuilder<List<EmergencyItem>>(
        future: ref
            .read(emergencyViewModelProvider.notifier)
            .getEmergencyList(dependentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyEmergencyCard(context);
          }

          final items = snapshot.data!.reversed.toList();
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isRead = item.checked;
              final time = DateFormat(
                'yyyy년 MM월 dd일\nHH시 mm분',
              ).format(item.createdAt);
              final voice =
                  item.keyword!.isNotEmpty ? item.keyword!.join(', ') : '음성 없음';
              final color =
                  isRead
                      ? CareConnectColor.neutral[100]
                      : CareConnectColor.secondary[200];

              return InkWell(
                onTap: () async {
                  final dependentName = await ref
                      .read(emergencyViewModelProvider.notifier)
                      .checkEmergency(items[index].emergencyId);

                  context.push(
                    '/notification/emergency',
                    extra: EmergencyDetailArgs(
                      emergency: items[index],
                      dependentName: dependentName!,
                    ),
                  );
                },
                child: Container(
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
                    children: [
                      isRead
                          ? SvgPicture.asset(
                            "assets/icons/emergency-family-false.svg",
                          )
                          : SvgPicture.asset(
                            "assets/icons/emergency-family.svg",
                          ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semibold_18px(text: '$time의 알람'),
                          SizedBox(height: 8),
                          Medium_16px(
                            text: "인식된 음성 : $voice",
                            color: CareConnectColor.neutral[600],
                          ),
                        ],
                      ),
                      Spacer(),
                      SvgPicture.asset(
                        "assets/icons/chevron-right.svg",
                        color: CareConnectColor.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget EmptyEmergencyCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/annotation-x.svg",
            color: CareConnectColor.neutral[400],
          ),
          SizedBox(height: 18),
          Semibold_24px(
            text: "긴급 알림이 없습니다.",
            color: CareConnectColor.neutral[400],
          ),
        ],
      ),
    );
  }
}
