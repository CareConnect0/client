import 'package:client/api/Notification/notification_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/notificationItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MyNotification extends ConsumerStatefulWidget {
  const MyNotification({super.key});

  @override
  ConsumerState<MyNotification> createState() => _MyNotificationState();
}

class _MyNotificationState extends ConsumerState<MyNotification> {
  @override
  void initState() {
    super.initState();
    // API 요청은 여기서 실행
    Future.microtask(() async {
      await ref
          .read(notificationViewModelProvider.notifier)
          .fetchAllNotifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationViewModelProvider);
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.white,
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "알림 확인", color: CareConnectColor.black),
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
                  color: CareConnectColor.neutral[700],
                ),
              ),
              SizedBox(width: 8),
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.neutral[700]),
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: CareConnectColor.neutral[200]!, width: 1),
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
                InkWell(
                  onTap: () async {
                    try {
                      await ref
                          .read(notificationViewModelProvider.notifier)
                          .deleteAllNotification();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('모든 알림이 삭제되었습니다.'),
                          backgroundColor: Colors.black87,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('전체 삭제 중 오류가 발생했어요.'),
                          backgroundColor: Colors.redAccent,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Text(
                    "모두 삭제",
                    style: TextStyle(
                      color: CareConnectColor.neutral[400],
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(context, ref, notification);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget NotificationCard(
    BuildContext context,
    WidgetRef ref,
    NotificationItem item,
  ) {
    final backgroundColor = getBackgroundColor(item.notificationType);
    final formattedDate = DateFormat(
      'yyyy년 MM월 dd일\nHH시 mm분',
    ).format(item.createdAt);

    return InkWell(
      onTap: () => context.push(getRoute(item.notificationType)),
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
            BoxShadow(
              color: CareConnectColor.white,
              blurRadius: 0,
              offset: Offset(0, 0),
            ),
          ],
          color: backgroundColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semibold_18px(text: item.title),
                  SizedBox(height: 16),
                  Medium_16px(
                    text: formattedDate,
                    color: CareConnectColor.neutral[600],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                try {
                  await ref
                      .read(notificationViewModelProvider.notifier)
                      .deleteNotification(item.notificationId);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('알림이 삭제되었습니다.'),
                      backgroundColor: Colors.black87,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('삭제 중 오류가 발생했어요.'),
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: SvgPicture.asset(
                "assets/icons/x-close.svg",
                color: CareConnectColor.neutral[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getBackgroundColor(String type) {
    switch (type) {
      case 'SCHEDULE_CREATE':
      case 'SCHEDULE_CREATE_BY_GUARDIAN':
        return CareConnectColor.primary[200]!.withOpacity(0.6);
      case 'CHAT':
        return CareConnectColor.primary[200]!.withOpacity(0.6);
      case 'EMERGENCY':
        return CareConnectColor.secondary[500]!.withOpacity(0.5);
      default:
        return CareConnectColor.primary[200]!;
    }
  }

  String getRoute(String type) {
    switch (type) {
      case 'SCHEDULE_CREATE':
      case 'SCHEDULE_CREATE_BY_GUARDIAN':
        return '/calendar';
      case 'CHAT':
        return '/contact';
      case 'EMERGENCY':
        return '/emergency/family';
      default:
        return '/notification';
    }
  }
}
