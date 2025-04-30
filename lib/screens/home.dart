import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerWidget {
  Home({super.key});

  final calendarNotificationProvider = StateProvider<bool>((ref) => true);
  final messengerNotificationProvider = StateProvider<bool>((ref) => true);
  final AINotificationProvider = StateProvider<bool>((ref) => true);
  final emergencyNotificationProvider = StateProvider<bool>((ref) => true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCalendarNotification = ref.watch(calendarNotificationProvider);
    final hasMessengerNotification = ref.watch(messengerNotificationProvider);
    final hasAINotification = ref.watch(AINotificationProvider);
    final hasEmergencyNotification = ref.watch(emergencyNotificationProvider);

    return Scaffold(
      appBar: AppbarWidget(),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MenuCard(
                        context,
                        '/calendar',
                        CareConnectColor.primary[900],
                        "달력",
                        "assets/icons/calendar.svg",
                        hasNotification: hasCalendarNotification),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Expanded(
                    child: MenuCard(context, '/', CareConnectColor.primary[400],
                        "메신저", "assets/icons/mail.svg",
                        hasNotification: hasMessengerNotification),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MenuCard(context, '/', CareConnectColor.primary[200],
                        "AI\n대화 도우미", "assets/icons/user.svg",
                        hasNotification: hasAINotification),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Expanded(
                    child: MenuCard(
                        context,
                        '/',
                        CareConnectColor.secondary[500],
                        "비상 호출",
                        "assets/icons/emergency-call.svg",
                        hasNotification: hasEmergencyNotification),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget AppbarWidget() {
    return PreferredSize(
      preferredSize: Size.fromHeight(160),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          color: CareConnectColor.primary[900],
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9800),
              blurRadius: 5,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Spacer(),
                SvgPicture.asset('assets/icons/bell.svg'),
                SizedBox(width: 12),
                SvgPicture.asset('assets/icons/settings.svg'),
              ],
            ),
            Bold_26px(
              text: "안녕하세요, 사용자님",
              color: CareConnectColor.white,
            ),
            Medium_20px(
              text: "오늘도 좋은 하루 되세요.",
              color: CareConnectColor.white,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget MenuCard(
      BuildContext context, link, color, String text, String assetName,
      {bool hasNotification = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: () {
            context.go(link);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 27),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF939393).withOpacity(0.25),
                  blurRadius: 8,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                Semibold_22px(
                  text: text,
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SvgPicture.asset(assetName),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasNotification)
          Positioned(
            top: -3,
            right: -3,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: CareConnectColor.secondary[300],
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
