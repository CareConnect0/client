import 'package:client/designs/CareConnectButton.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectDialog.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, Map<String, List<String>>>(
  (ref) => ScheduleNotifier(),
);

class ScheduleNotifier extends StateNotifier<Map<String, List<String>>> {
  ScheduleNotifier()
      : super({
          '07:00': ['비타민 복용', '아침 식사'],
          '10:00': ['회의'],
          '14:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
          '15:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
          '16:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
        });

  void modifySchedule(String time, String oldEvent, String newEvent) {
    final updated = [...state[time]!];
    final index = updated.indexOf(oldEvent);
    if (index != -1) {
      updated[index] = newEvent;
      state = {
        ...state,
        time: updated,
      };
    }
  }

  void deleteSchedule(String time, String event) {
    final updated = [...state[time]!];
    updated.remove(event);
    state = {
      ...state,
      time: updated,
    };
  }
}

class TimeTable extends ConsumerWidget {
  final DateTime selected;

  TimeTable(this.selected, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedule = ref.watch(scheduleProvider);

    return FractionallySizedBox(
      heightFactor: (MediaQuery.of(context).size.height - 100) /
          MediaQuery.of(context).size.height,
      child: Container(
        decoration: BoxDecoration(
          color: CareConnectColor.neutral[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: CareConnectColor.primary[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Medium_18px(
                text: DateFormat('yyyy년 MM월 dd일 (E)', 'ko_KR').format(selected),
              ),
            ),

            // 일정 리스트
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final time = schedule.keys.elementAt(index);
                  final eventsAtTime = schedule[time]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CareConnectColor.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 4,
                            color: CareConnectColor.black.withOpacity(0.15),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Medium_23px(
                            text: time,
                            color: CareConnectColor.black,
                          ),
                          const SizedBox(width: 28),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: eventsAtTime.map((event) {
                                final controller =
                                    TextEditingController(text: event);

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CareConnectDialog(
                                            time: time,
                                            scheduleText: event,
                                            scheduleController: controller,
                                            cancel: () {
                                              controller.text = event;
                                              context.pop();
                                            },
                                            modify: () {
                                              ref
                                                  .read(
                                                      scheduleProvider.notifier)
                                                  .modifySchedule(
                                                    time,
                                                    event,
                                                    controller.text,
                                                  );
                                              context.pop();
                                            },
                                            delete: () {
                                              ref
                                                  .read(
                                                      scheduleProvider.notifier)
                                                  .deleteSchedule(time, event);
                                              context.pop();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/icons/person.svg'),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Medium_16px(text: event)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 일정 추가 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      color: CareConnectColor.black.withOpacity(0.3),
                    )
                  ],
                ),
                child: CareConnectButton(
                  onPressed: () {
                    // 일정 추가 로직 작성
                  },
                  text: '일정 추가하기',
                  textColor: CareConnectColor.white,
                  assetName: 'assets/icons/plus.svg',
                  backgroundColor: CareConnectColor.primary[900]!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
