// ignore_for_file: prefer_const_constructors

import 'package:client/api/Schedule/guardian_view_model.dart';
import 'package:client/api/Schedule/schedule_view_model.dart';
import 'package:client/designs/CareConnectButton.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/YearMonth.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends ConsumerWidget {
  Calendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            context.go('/home');
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 34),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CareConnectColor.primary[900],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Bold_20px(
                        text: "날짜를 눌러 일정을 추가해보세요!",
                        color: CareConnectColor.white,
                      ),
                    ),
                  ),
                  Container(width: double.infinity, child: MonthCalendar()),
                  SizedBox(height: 18),
                  InkWell(
                    onTap: () => context.go('/home'),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CareConnectColor.primary[900],
                        boxShadow: [
                          BoxShadow(
                            color: CareConnectColor.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/union.svg'),
                          Semibold_16px(
                            text: "홈 화면",
                            color: CareConnectColor.white,
                          ),
                        ],
                      ),
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
}

final calendarFormatProvider = StateProvider<CalendarFormat>(
  (ref) => CalendarFormat.month,
);
final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
final selectedDayProvider = StateProvider<DateTime?>((ref) => null);

class MonthCalendar extends ConsumerStatefulWidget {
  const MonthCalendar({super.key});

  @override
  ConsumerState<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends ConsumerState<MonthCalendar> {
  YearMonth? _lastFetchedYM;
  YearMonthGuardian? _lastFetchedGYM;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final ym = YearMonth(now.year, now.month);
    final dym = YearMonthGuardian(
      dependentId: ref.read(dependentSelectedIdProvider),
      year: now.year,
      month: now.month,
    );
    _lastFetchedYM = ym;
    _lastFetchedGYM = dym;

    // 초기 데이터를 미리 fetch하도록 프리로드
    Future.microtask(() {
      if (ref.read(userTypeProvider) == "DEPENDENT") {
        ref.read(scheduleMonthProvider(ym));
      } else {
        print(ref.read(dependentSelectedIdProvider));
        ref.read(scheduleMonthGuardianProvider(dym));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarFormat = ref.watch(calendarFormatProvider);
    final focusedDay = ref.watch(focusedDayProvider);
    final selectedDay = ref.watch(selectedDayProvider);
    final dependentId = ref.watch(dependentSelectedIdProvider);
    final userType = ref.watch(userTypeProvider);

    final currentYM = YearMonth(focusedDay.year, focusedDay.month);
    final currentGYM = YearMonthGuardian(
      dependentId: dependentId,
      year: focusedDay.year,
      month: focusedDay.month,
    );

    final monthlyScheduleAsync =
        userType == "DEPENDENT"
            ? ref.watch(scheduleMonthProvider(currentYM))
            : ref.watch(scheduleMonthGuardianProvider(currentGYM));

    return monthlyScheduleAsync.when(
      data: (dateList) {
        final events = <DateTime, List<String>>{};
        for (final date in dateList) {
          final key = DateTime.utc(date.year, date.month, date.day);
          events[key] = ['일정 있음']; // 임의 텍스트
        }
        return Column(
          children: [
            // nnnn년 n월
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              color: CareConnectColor.neutral[700],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      ref.read(focusedDayProvider.notifier).state = focusedDay
                          .subtract(Duration(days: 30));
                    },
                    child: SvgPicture.asset('assets/icons/circle-left.svg'),
                  ),
                  Text(
                    DateFormat('y년 M월', 'ko_KR').format(focusedDay),
                    style: TextStyle(
                      color: CareConnectColor.white,
                      fontFamily: 'Pretendard',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ref.read(focusedDayProvider.notifier).state = focusedDay
                          .add(Duration(days: 30));
                    },
                    child: SvgPicture.asset('assets/icons/circle-right.svg'),
                  ),
                ],
              ),
            ),
            // 달력 body
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: CareConnectColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                headerVisible: false,
                daysOfWeekHeight: 55,
                // 요일
                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, locale) {
                    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
                    return weekdays[date.weekday % 7];
                  },
                  weekdayStyle: TextStyle(
                    color: CareConnectColor.neutral[500],
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: TextStyle(
                    color: CareConnectColor.neutral[500],
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // 날짜
                calendarStyle: CalendarStyle(
                  markersAlignment: Alignment.topRight,
                  canMarkersOverflow: true,
                  markersMaxCount: 1,
                  markersAnchor: 0.7,
                  outsideDaysVisible: false,
                ),
                calendarBuilders: CalendarBuilders(
                  // 일정 있을 경우 마크 표시
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        top: -5,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CareConnectColor.primary[900],
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                  // 오늘 날짜
                  todayBuilder: (context, day, focusedDay) {
                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -5,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CareConnectColor.secondary[500],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Medium_18px(
                            text: '${day.day}',
                            color: CareConnectColor.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Bold_13px(
                            text: '오늘',
                            color: CareConnectColor.secondary[500],
                          ),
                        ),
                      ],
                    );
                  },
                  // 선택된 날짜
                  selectedBuilder: (context, day, focusedDay) {
                    return Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: -5,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CareConnectColor.primary[100],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Medium_18px(
                            text: '${day.day}',
                            color: CareConnectColor.black,
                          ),
                        ),
                      ],
                    );
                  },
                  // 기본 날짜
                  defaultBuilder: (context, day, focusedDay) {
                    return Center(
                      child: Column(
                        children: [
                          Medium_18px(
                            text: '${day.day}',
                            color: CareConnectColor.black,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // 주간 높이
                rowHeight: 54,
                focusedDay: focusedDay,
                // 달력 시작 날짜
                firstDay: DateTime.utc(DateTime.now().year, 01, 01),
                // 달력 종료 날짜
                lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDay, day);
                },
                onDaySelected: (selected, focused) {
                  ref.read(selectedDayProvider.notifier).state = selected;
                  ref.read(focusedDayProvider.notifier).state = focused;

                  context.push('/calendar/timetable', extra: selected);
                },
                onFormatChanged: (format) {
                  ref.read(calendarFormatProvider.notifier).state = format;
                },
                onPageChanged: (focused) {
                  ref.read(focusedDayProvider.notifier).state = focused;
                },
                calendarFormat: calendarFormat,
                eventLoader: (day) {
                  return events[DateTime.utc(day.year, day.month, day.day)] ??
                      [];
                },
              ),
            ),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('일정 정보를 불러오는 중 오류가 발생했습니다.')),
    );
  }
}
