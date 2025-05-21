import 'package:client/api/Schedule/guardian_view_model.dart';
import 'package:client/api/Schedule/schedule_view_model.dart';
import 'package:client/designs/CareConnectButton.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectDialog.dart';
import 'package:client/designs/TimePickerDialog.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/YearMonth.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final scheduleProvider =
    StateNotifierProvider<ScheduleNotifier, Map<String, List<ScheduleInfo>>>(
      (ref) => ScheduleNotifier(),
    );

final dependentIdListProvider = StateProvider<List<int>>((ref) => [0]);
final dependentSelectedIdProvider = StateProvider<int>((ref) => 0);

class ScheduleNotifier extends StateNotifier<Map<String, List<ScheduleInfo>>> {
  ScheduleNotifier() : super({});

  void modifySchedule(String time, ScheduleInfo oldEvent, String newContent) {
    final updated = [...state[time]!];
    final index = updated.indexWhere(
      (e) => e.scheduleId == oldEvent.scheduleId,
    );
    if (index != -1) {
      updated[index] = ScheduleInfo(
        scheduleId: oldEvent.scheduleId,
        content: newContent,
        dateTime: oldEvent.dateTime,
      );
      state = {...state, time: updated};
    }
  }

  void deleteSchedule(String time, ScheduleInfo event) {
    final updated = [...state[time]!];
    updated.removeWhere((e) => e.scheduleId == event.scheduleId);
    state = {...state, time: updated};
  }

  void setSchedulesFromAPI(List<ScheduleInfo> schedules) {
    final Map<String, List<ScheduleInfo>> grouped = {};

    for (var schedule in schedules) {
      final dateTime = schedule.dateTime;
      final hourStr = DateFormat('HH:mm').format(dateTime);

      if (grouped[hourStr] == null) {
        grouped[hourStr] = [];
      }

      grouped[hourStr]!.add(schedule);
    }

    state = grouped;
  }
}

class TimeTable extends ConsumerStatefulWidget {
  final DateTime selected;

  const TimeTable(this.selected, {super.key});

  @override
  ConsumerState<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends ConsumerState<TimeTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(userTypeProvider) == "DEPENDENT") {
        // 일정 조회 API 호출 (피보호자)
        ref
            .read(scheduleViewModelProvider.notifier)
            .getSchedules(widget.selected);
      } else {
        // 일정 조회 API 호출 (보호자)
        final selectedIndex = ref.watch(selectProvider); // 현재 선택된 인덱스
        final dependentIds = ref.watch(dependentIdListProvider); // ID 리스트
        if (dependentIds.isNotEmpty && selectedIndex < dependentIds.length) {
          final selectedDependentId = dependentIds[selectedIndex];

          ref
              .read(scheduleGuardianViewModelProvider.notifier)
              .getGuardianSchedules(selectedDependentId, widget.selected);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final schedule = ref.watch(scheduleProvider);

    final selectedIndex = ref.watch(selectProvider); // 현재 선택된 인덱스
    final dependentIds = ref.watch(dependentIdListProvider); // ID 리스트
    final selectedDependentId = dependentIds[selectedIndex];

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "달력", color: CareConnectColor.white),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            // 해당 월 일정 새로고침
            if (ref.read(userTypeProvider) == "DEPENDENT") {
              final ym = YearMonth(widget.selected.year, widget.selected.month);
              ref.invalidate(scheduleMonthProvider(ym));
            } else {
              final dym = YearMonthGuardian(
                dependentId: ref.read(dependentSelectedIdProvider),
                year: widget.selected.year,
                month: widget.selected.month,
              );
              ref.invalidate(scheduleMonthGuardianProvider(dym));
            }
            context.go('/calendar');
          },
          child: Row(
            children: [
              SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              SizedBox(width: 8),
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.white),
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: CareConnectColor.neutral[200]!, width: 1),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
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
          mainAxisAlignment: MainAxisAlignment.end,
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
                text: DateFormat(
                  'yyyy년 MM월 dd일 (E)',
                  'ko_KR',
                ).format(widget.selected),
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
                      horizontal: 24,
                      vertical: 12,
                    ),
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
                              children:
                                  eventsAtTime.map((schedule) {
                                    final controller = TextEditingController(
                                      text: schedule.content,
                                    );

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 9),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CareConnectDialog(
                                                time: time,
                                                scheduleText: schedule.content!,
                                                scheduleController: controller,
                                                cancel: () {
                                                  controller.text =
                                                      schedule.content!;
                                                  context.pop();
                                                },
                                                modify: () async {
                                                  if (ref.read(
                                                        userTypeProvider,
                                                      ) ==
                                                      "DEPENDENT") {
                                                    // 피보호자
                                                    final newInfo =
                                                        ScheduleInfo(
                                                          scheduleId:
                                                              schedule
                                                                  .scheduleId,
                                                          content:
                                                              controller.text,
                                                          dateTime:
                                                              schedule.dateTime,
                                                        );
                                                    await ref
                                                        .read(
                                                          scheduleViewModelProvider
                                                              .notifier,
                                                        )
                                                        .modifySchedule(
                                                          newInfo,
                                                        );
                                                    await ref
                                                        .read(
                                                          scheduleViewModelProvider
                                                              .notifier,
                                                        )
                                                        .getSchedules(
                                                          widget.selected,
                                                        );
                                                  } else
                                                  // 보호자
                                                  {
                                                    final newInfoGuardian =
                                                        ScheduleInfo(
                                                          dependentId:
                                                              selectedDependentId,
                                                          scheduleId:
                                                              schedule
                                                                  .scheduleId,
                                                          content:
                                                              controller.text,
                                                          dateTime:
                                                              schedule.dateTime,
                                                        );
                                                    await ref
                                                        .read(
                                                          scheduleGuardianViewModelProvider
                                                              .notifier,
                                                        )
                                                        .modifyGuardianSchedule(
                                                          newInfoGuardian,
                                                        );
                                                    await ref
                                                        .read(
                                                          scheduleGuardianViewModelProvider
                                                              .notifier,
                                                        )
                                                        .getGuardianSchedules(
                                                          selectedDependentId,
                                                          widget.selected,
                                                        );
                                                  }
                                                  context.pop();
                                                },
                                                delete: () async {
                                                  if (ref.read(
                                                        userTypeProvider,
                                                      ) ==
                                                      "DEPENDENT") {
                                                    // 피보호자
                                                    await ref
                                                        .read(
                                                          scheduleViewModelProvider
                                                              .notifier,
                                                        )
                                                        .deleteSchedule(
                                                          schedule.scheduleId!,
                                                        );

                                                    await ref
                                                        .read(
                                                          scheduleViewModelProvider
                                                              .notifier,
                                                        )
                                                        .getSchedules(
                                                          widget.selected,
                                                        );
                                                  } else {
                                                    // 보호자
                                                    await ref
                                                        .read(
                                                          scheduleGuardianViewModelProvider
                                                              .notifier,
                                                        )
                                                        .deleteGuardianSchedule(
                                                          schedule.scheduleId!,
                                                          selectedDependentId,
                                                        );

                                                    await ref
                                                        .read(
                                                          scheduleGuardianViewModelProvider
                                                              .notifier,
                                                        )
                                                        .getGuardianSchedules(
                                                          selectedDependentId,
                                                          widget.selected,
                                                        );
                                                  }

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
                                                'assets/icons/person.svg',
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Medium_16px(
                                                text: schedule.content!,
                                              ),
                                            ),
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
                    ),
                  ],
                ),
                child: CareConnectButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => CareConnectTimePickerDialog(
                            onTimeSelected: (period, hour, minute) {
                              int hour24 =
                                  (period == '오전') ? hour : (hour % 12) + 12;

                              // 날짜 + 시간 조합
                              final selectedDateTime = DateTime(
                                widget.selected.year,
                                widget.selected.month,
                                widget.selected.day,
                                hour24,
                                minute,
                              );

                              if (ref.read(userTypeProvider) == "DEPENDENT") {
                                // 피보호자
                                final info = ScheduleInfo(
                                  dateTime: selectedDateTime,
                                );
                                context.pop();
                                context.push('/calendar/enroll', extra: info);
                              } else {
                                // 보호자
                                final infoGuardian = ScheduleInfo(
                                  dependentId: selectedDependentId,
                                  dateTime: selectedDateTime,
                                );
                                context.pop();
                                context.push(
                                  '/calendar/enroll',
                                  extra: infoGuardian,
                                );
                              }
                            },
                            onPressed: () {},
                          ),
                    );
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
