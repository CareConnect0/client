class RecorderModel {
  final bool isRecording;
  final String statusText;
  final String? recordedFilePath;
  final bool readyForNavigation;

  RecorderModel({
    required this.isRecording,
    required this.statusText,
    this.recordedFilePath,
    this.readyForNavigation = false,
  });

  RecorderModel copyWith({
    bool? isRecording,
    String? statusText,
    String? recordedFilePath,
    bool? readyForNavigation,
  }) {
    return RecorderModel(
      isRecording: isRecording ?? this.isRecording,
      statusText: statusText ?? this.statusText,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      readyForNavigation: readyForNavigation ?? this.readyForNavigation,
    );
  }
}
