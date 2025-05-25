import 'dart:async';

import 'package:client/api/Assistant/assistant_view_model.dart';
import 'package:client/api/Notification/notification_view_model.dart';
import 'package:client/api/User/user_view_model.dart';
import 'package:client/api/emergency/emergency_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

final selectProvider = StateProvider<int>((ref) => 0);
final dependentNameAndImageProvider = StateProvider<Map<String, String>>(
  (ref) => {},
);
final userNameProvider = StateProvider<String>((ref) => '');
final userTypeProvider = StateProvider<String>((ref) => '');
final userProfileUrlProvider = StateProvider<String>((ref) => '');
Timer? _notificationTimer;

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
    // API 요청은 여기서 실행
    Future.microtask(() async {
      await ref.read(userViewModelProvider.notifier).getMine();
      if (ref.read(userTypeProvider) != "DEPENDENT") {
        await ref.read(userViewModelProvider.notifier).getDependents();

        final selectedIndex = ref.watch(selectProvider); // 현재 선택된 인덱스
        final dependentIds = ref.watch(dependentIdListProvider); // ID 리스트
        final selectedDependentId = dependentIds[selectedIndex];
        ref.watch(dependentSelectedIdProvider.notifier).state =
            selectedDependentId;
      }
      // 알림 여부 조회
      await ref.read(hasNotificationProvider.notifier).fetchUnreadStatus();

      // 이후 주기적으로 알림 여부 갱신
      _notificationTimer = Timer.periodic(const Duration(seconds: 60), (
        _,
      ) async {
        await ref.read(hasNotificationProvider.notifier).fetchUnreadStatus();
      });
    });
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 알림 여부 조회
    final hasNotification = ref.watch(hasNotificationProvider);
    final hasCalendarNotification = hasNotification?.hasUnreadSchedule ?? false;
    final hasMessengerNotification = hasNotification?.hasUnreadChat ?? false;
    final hasEmergencyNotification =
        hasNotification?.hasUnreadEmergency ?? false;
    final type = ref.watch(userTypeProvider);

    return Scaffold(
      appBar: AppbarWidget(context, ref),
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
                      onTap: () {
                        context.push('/calendar');
                      },
                      color: CareConnectColor.primary[900]!,
                      text: "달력",
                      assetName: "assets/icons/calendar.svg",
                      hasNotification: hasCalendarNotification,
                    ),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: MenuCard(
                      context,
                      onTap: () {
                        context.push('/contact');
                      },
                      color: CareConnectColor.primary[400]!,
                      text: "메신저",
                      assetName: "assets/icons/mail.svg",
                      hasNotification: hasMessengerNotification,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 13),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: MenuCard(
                      context,
                      onTap: () {
                        context.push('/ai');
                      },
                      color: CareConnectColor.primary[200]!,
                      text: "AI\n대화 도우미",
                      assetName: "assets/icons/user.svg",
                      hasNotification: false,
                    ),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child:
                        type != "DEPENDENT"
                            ? MenuCard(
                              context,
                              onTap: () {
                                context.push('/emergency/family');
                              },
                              color: CareConnectColor.secondary[500]!,
                              text: "비상 호출",
                              assetName: "assets/icons/emergency-call.svg",
                              hasNotification: hasEmergencyNotification,
                            )
                            : MenuCard(
                              context,
                              color: CareConnectColor.secondary[500]!,
                              text: "비상 호출",
                              assetName: "assets/icons/emergency-call.svg",
                              onTap: () async {
                                await ref
                                    .read(emergencyViewModelProvider.notifier)
                                    .enrollEmergency();
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text('비상 호출 버튼을 클릭하셨습니다.')),
                                );
                              },
                              hasNotification: hasEmergencyNotification,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget AppbarWidget(BuildContext context, ref) {
    final type = ref.watch(userTypeProvider);
    final selectedIndex = ref.watch(selectProvider);
    final dependentNameAndImage = ref.watch(dependentNameAndImageProvider);
    final names = dependentNameAndImage.keys.toList();

    return PreferredSize(
      preferredSize: Size.fromHeight(160),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
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
                InkWell(
                  onTap: () => context.push('/notification'),
                  child: SvgPicture.asset('assets/icons/bell.svg'),
                ),
                SizedBox(width: 12),
                InkWell(
                  onTap: () => context.push('/profile'),
                  child: SvgPicture.asset('assets/icons/settings.svg'),
                ),
              ],
            ),
            Bold_26px(
              text: "안녕하세요, ${ref.watch(userNameProvider)}님",
              color: CareConnectColor.white,
            ),
            type == "DEPENDENT"
                ? Medium_20px(
                  text: "오늘도 좋은 하루 되세요.",
                  color: CareConnectColor.white,
                )
                : Row(
                  children: [
                    Medium_20px(
                      text: "현재 피보호자님은 ",
                      color: CareConnectColor.white,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => SelectDialog(ref),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6600),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            (names.length == 0)
                                ? Medium_18px(
                                  text: '없음',
                                  color: CareConnectColor.white,
                                )
                                : Medium_18px(
                                  text: names[selectedIndex],
                                  color: CareConnectColor.white,
                                ),
                            SizedBox(width: 8),
                            SvgPicture.asset(
                              "assets/icons/chevron-down.svg",
                              color: CareConnectColor.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      child: Medium_20px(
                        text: " 입니다.",
                        color: CareConnectColor.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget MenuCard(
    BuildContext context, {
    required String text,
    required String assetName,
    required Color color,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
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
                Semibold_22px(text: text, textAlign: TextAlign.center),
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

  Widget SelectDialog(ref) {
    final selectedIndex = ref.watch(selectProvider);
    final dependentNameAndImage = ref.watch(dependentNameAndImageProvider);
    final names = dependentNameAndImage.keys.toList();

    return Dialog(
      backgroundColor: CareConnectColor.neutral[100],
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        constraints: BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: CareConnectColor.primary[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Bold_20px(
                  text: "피보호자를 선택해주세요",
                  color: CareConnectColor.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: names.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    ref.read(selectProvider.notifier).state = index;

                    final selectedIndex = ref.watch(
                      selectProvider,
                    ); // 현재 선택된 인덱스
                    final dependentIds = ref.watch(
                      dependentIdListProvider,
                    ); // ID 리스트
                    final selectedDependentId = dependentIds[selectedIndex];
                    ref.watch(dependentSelectedIdProvider.notifier).state =
                        selectedDependentId;
                    context.pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
                    decoration: BoxDecoration(
                      color:
                          selectedIndex == index
                              ? CareConnectColor.primary[200]
                              : CareConnectColor.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            selectedIndex == index
                                ? CareConnectColor.primary[900]!
                                : CareConnectColor.white,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  dependentNameAndImage[names[index]]!
                                          .isNotEmpty
                                      ? NetworkImage(
                                        dependentNameAndImage[names[index]]!,
                                      )
                                      : AssetImage("assets/images/example.png"),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Medium_20px(text: names[index]),
                        Spacer(),
                        selectedIndex == index
                            ? Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CareConnectColor.primary[900],
                              ),
                              child: SvgPicture.asset("assets/icons/check.svg"),
                            )
                            : Container(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
