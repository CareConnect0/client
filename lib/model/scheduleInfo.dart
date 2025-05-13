import 'package:intl/intl.dart';

class ScheduleInfo {
  final int? scheduleId;
  final String content;
  final DateTime dateTime;

  ScheduleInfo({
    this.scheduleId,
    required this.content,
    required this.dateTime,
  });

  /// 서버에 보낼 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'startTime': startTime,
    };
  }

  /// 서버에서 받은 JSON으로부터 ScheduleInfo 생성
  factory ScheduleInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleInfo(
      scheduleId: json['scheduleId'],
      content: json['content'],
      dateTime: DateTime.parse(json['startTime']),
    );
  }

  String get formattedDate => DateFormat('yyyy-MM-dd').format(dateTime);
  String get formattedTime => DateFormat('HH:mm').format(dateTime);

  /// API에 보낼 포맷
  String _formatDateTime(DateTime dt) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dt);
  }

  String get startTime => _formatDateTime(dateTime).toString();
}
