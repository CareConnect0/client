import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/record/controller.dart';
import 'package:client/screens/record/viewModel.dart';
import 'package:client/screens/record/waveform/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class EnrollSchedule extends ConsumerStatefulWidget {
  const EnrollSchedule({super.key});

  @override
  ConsumerState<EnrollSchedule> createState() => _EnrollScheduleState();
}

class _EnrollScheduleState extends ConsumerState<EnrollSchedule> {
  @override
  Widget build(BuildContext context) {
    final recorderState = ref.watch(recorderViewModelProvider); // ViewModel 상태
    final viewModelNotifier =
        ref.read(recorderViewModelProvider.notifier); // 액션
    final recorderController = ref.read(recorderControllerProvider); // 파형 컨트롤러

    // 녹음이 끝나면 자동 이동
    final info = GoRouterState.of(context).extra as ScheduleInfo;
    if (recorderState.readyForNavigation) {
      Future.microtask(() {
        viewModelNotifier.resetNavigation();

        context.go('/calendar/enroll/confirm', extra: info);
      });
    }

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: recorderState.isRecording
          ? null
          : AppBar(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (recorderState.isRecording) const CustomRecordingWaveWidget(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Bold_30px(
              text: recorderState.statusText,
              color: CareConnectColor.white,
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () =>
                  viewModelNotifier.toggleRecording(recorderController),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: CareConnectColor.white,
                  ),
                ),
                child: recorderState.isRecording
                    ? Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.all(27),
                        decoration: BoxDecoration(
                          color: CareConnectColor.secondary[500],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CareConnectColor.secondary[500],
                        ),
                      ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }
}
