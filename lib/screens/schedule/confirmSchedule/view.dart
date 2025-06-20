import 'package:client/api/Schedule/guardian_view_model.dart';
import 'package:client/api/Schedule/schedule_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/record/controller.dart';
import 'package:client/screens/record/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConfirmSchedule extends ConsumerWidget {
  const ConfirmSchedule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = GoRouterState.of(context).extra as ScheduleInfo;
    final recorderController = ref.read(recorderControllerProvider);

    Text('선택한 날짜: ${DateFormat('yyyy-MM-dd').format(info.dateTime)}');

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      body: Center(
        child: SingleChildScrollView(
          child: Bold_36px(
            text:
                "${DateFormat('MM월 dd일').format(info.dateTime)}\n${info.formattedTime}에\n[${info.content}]\n일정을 등록할까요?",
            color: CareConnectColor.white,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (ref.read(userTypeProvider) == "DEPENDENT") {
                    // 피보호자
                    await ref
                        .read(scheduleViewModelProvider.notifier)
                        .enrollSchedule(info);
                  } else {
                    // 보호자
                    await ref
                        .read(scheduleGuardianViewModelProvider.notifier)
                        .enrollGuardianSchedule(info);
                  }
                  ref
                      .read(recorderViewModelProvider.notifier)
                      .resetAll(recorderController);
                  // 등록 후 이동
                  context.go('/calendar/timetable', extra: info.dateTime);
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: CareConnectColor.primary[900],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Bold_26px(text: "등록", color: CareConnectColor.white),
                  ),
                ),
              ),
            ),
            SizedBox(width: 24),
            Expanded(
              child: InkWell(
                onTap: () {
                  ref
                      .read(recorderViewModelProvider.notifier)
                      .resetAll(recorderController);
                  context.push('/calendar/enroll', extra: info);
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: CareConnectColor.primary[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Bold_26px(
                      text: "다시 녹음",
                      color: CareConnectColor.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
