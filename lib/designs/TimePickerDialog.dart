import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 선택된 시간 정보를 저장하는 상태 프로바이더
final selectedTimeProvider =
    StateNotifierProvider<SelectedTimeNotifier, SelectedTimeState>((ref) {
  return SelectedTimeNotifier();
});

// 시간 상태 클래스
class SelectedTimeState {
  final String period;
  final int hour;
  final int minute;

  SelectedTimeState({
    this.period = '오전',
    this.hour = 9,
    this.minute = 0,
  });

  SelectedTimeState copyWith({
    String? period,
    int? hour,
    int? minute,
  }) {
    return SelectedTimeState(
      period: period ?? this.period,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}

// 시간 상태 관리 노티파이어
class SelectedTimeNotifier extends StateNotifier<SelectedTimeState> {
  SelectedTimeNotifier() : super(SelectedTimeState());

  void updatePeriod(String period) {
    state = state.copyWith(period: period);
  }

  void updateHour(int hour) {
    state = state.copyWith(hour: hour);
  }

  void updateMinute(int minute) {
    state = state.copyWith(minute: minute);
  }

  void updateTime(String period, int hour, int minute) {
    state = SelectedTimeState(
      period: period,
      hour: hour,
      minute: minute,
    );
  }
}

// 시간 선택 다이얼로그 위젯
class CareConnectTimePickerDialog extends ConsumerWidget {
  // 옵션 리스트
  final List<String> periods = ['오전', '오후'];
  final List<int> hours = List.generate(12, (index) => index + 1);
  final List<int> minutes = List.generate(60, (index) => index);

  final Function(String period, int hour, int minute)? onTimeSelected;
  final VoidCallback? onPressed;

  CareConnectTimePickerDialog({Key? key, this.onTimeSelected, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeState = ref.watch(selectedTimeProvider);

    // 현재 선택된 인덱스를 계산
    final selectedPeriodIndex = periods.indexOf(timeState.period);
    final selectedHourIndex = hours.indexOf(timeState.hour);
    final selectedMinuteIndex = minutes.indexOf(timeState.minute);

    // 항목 설정
    const double itemExtent = 35.0;

    return AlertDialog(
      backgroundColor: CareConnectColor.neutral[700],
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 상단 버튼 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Semibold_18px(
                    text: "취소",
                    color: CareConnectColor.primary[900],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (onTimeSelected != null) {
                      onTimeSelected!(
                          timeState.period, timeState.hour, timeState.minute);
                    }
                    // Navigator.of(context).pop(timeState);
                    onPressed?.call();
                  },
                  child: Semibold_18px(
                    text: "다음",
                    color: CareConnectColor.primary[900],
                  ),
                ),
              ],
            ),
            // 시간 선택 박스
            Stack(
              children: [
                Positioned.fill(
                  child: Center(
                    child: Container(
                      height: itemExtent,
                      decoration: BoxDecoration(
                        color: CareConnectColor.neutral[600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 오전/오후 선택 스피너
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: itemExtent,
                            diameterRatio: 10.0, // 매우 큰 값으로 설정하여 곡률 최소화
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              ref
                                  .read(selectedTimeProvider.notifier)
                                  .updatePeriod(periods[index]);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: periods.length,
                              builder: (context, index) {
                                final isSelected = index == selectedPeriodIndex;
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    periods[index],
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: isSelected
                                          ? CareConnectColor.white
                                          : CareConnectColor.white.withOpacity(
                                              isSelected ? 1.0 : 0.3),
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 40,
                      ),

                      // 시간 선택 스피너
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: itemExtent,
                            diameterRatio: 10.0,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              ref
                                  .read(selectedTimeProvider.notifier)
                                  .updateHour(hours[index]);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: hours.length,
                              builder: (context, index) {
                                final isSelected = index == selectedHourIndex;
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    hours[index].toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: isSelected
                                          ? CareConnectColor.white
                                          : CareConnectColor.white.withOpacity(
                                              isSelected ? 1.0 : 0.3),
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 12,
                      ),

                      // 분 선택 스피너
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: itemExtent,
                            diameterRatio: 10.0,
                            physics: FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              ref
                                  .read(selectedTimeProvider.notifier)
                                  .updateMinute(minutes[index]);
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: minutes.length,
                              builder: (context, index) {
                                final isSelected = index == selectedMinuteIndex;
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    minutes[index].toString().padLeft(2, '0'),
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: isSelected
                                          ? CareConnectColor.white
                                          : CareConnectColor.white.withOpacity(
                                              isSelected ? 1.0 : 0.3),
                                      fontWeight: isSelected
                                          ? FontWeight.w500
                                          : FontWeight.normal,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: Column(
                      children: [
                        Container(
                          height: 50, // 윗 그라디언트
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                CareConnectColor.neutral[700]!.withOpacity(1),
                                CareConnectColor.neutral[700]!.withOpacity(0.5),
                                CareConnectColor.neutral[700]!.withOpacity(0.3),
                                CareConnectColor.neutral[700]!.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container(color: Colors.transparent)),
                        Container(
                          height: 50, // 아랫 그라디언트
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                CareConnectColor.neutral[700]!.withOpacity(1),
                                CareConnectColor.neutral[700]!.withOpacity(0.5),
                                CareConnectColor.neutral[700]!.withOpacity(0.3),
                                CareConnectColor.neutral[700]!.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
