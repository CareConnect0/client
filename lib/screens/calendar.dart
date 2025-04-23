// ignore_for_file: prefer_const_constructors

import 'package:client/designs/CareConnectButton.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
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
        title: Bold_22px(
          text: "달력",
          color: CareConnectColor.white,
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
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              SizedBox(
                width: 8,
              ),
              Semibold_16px(
                text: "뒤로가기",
                color: CareConnectColor.white,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 34),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CareConnectColor.primary[900],
                  ),
                  child: Bold_20px(
                    text: "날짜를 눌러 일정을 추가해보세요!",
                    color: CareConnectColor.white,
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: MonthCalendar(),
                ),
                SizedBox(
                  height: 18,
                ),
                Container(
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
                        )
                      ]),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  final calendarFormatProvider =
      StateProvider<CalendarFormat>((ref) => CalendarFormat.month);
  final focusedDayProvider = StateProvider<DateTime>((ref) => DateTime.now());
  final selectedDayProvider = StateProvider<DateTime?>((ref) => null);

  Widget MonthCalendar() {
    // 예시 이벤트 목록 ...TODO: api 연결
    final Map<DateTime, List<String>> events = {
      DateTime.utc(2025, 3, 15): ['Event 1'],
      DateTime.utc(2025, 4, 15): ['Event 1'],
      DateTime.utc(2025, 4, 19): ['Event 1'],
      DateTime.utc(2025, 4, 23): ['Event 2'],
    };

    return Consumer(
      builder: (context, ref, _) {
        final calendarFormat = ref.watch(calendarFormatProvider);
        final focusedDay = ref.watch(focusedDayProvider);
        final selectedDay = ref.watch(selectedDayProvider);

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
                      ref.read(focusedDayProvider.notifier).state =
                          focusedDay.subtract(Duration(days: 30));
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
                      ref.read(focusedDayProvider.notifier).state =
                          focusedDay.add(Duration(days: 30));
                    },
                    child: SvgPicture.asset('assets/icons/circle-right.svg'),
                  ),
                ],
              ),
            ),
            // 달력 body
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: CareConnectColor.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TableCalendar(
                headerVisible: false,
                daysOfWeekHeight: 60,
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
                          top: -7,
                          child: Container(
                            width: 40,
                            height: 40,
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
                          top: -7,
                          child: Container(
                            width: 40,
                            height: 40,
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

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    barrierColor: Colors.transparent,
                    // backgroundColor: CareConnectColor.neutral[100],
                    builder: (context) => TimeTable(selected, context),
                  );
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
    );
  }

  Widget TimeTable(DateTime selected, BuildContext context) {
    // 예시용 일정 목록
    final Map<String, List<String>> schedule = {
      '07:00': ['비타민 복용', '아침 식사'],
      '10:00': ['회의'],
      '14:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
      // '15:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
      // '16:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
      // '17:00': ['병원 예약', '내시경 검사 받으러 가기 ( 병원명 )'],
    };

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
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
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
                                      Expanded(child: Medium_16px(text: event)),
                                    ],
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
