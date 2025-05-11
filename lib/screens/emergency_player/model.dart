class PlayerModel {
  final bool isPlaying;
  final bool isFinished;
  final String statusText;
  final String? recordedFilePath;

  PlayerModel({
    required this.isPlaying,
    required this.isFinished,
    required this.statusText,
    this.recordedFilePath,
  });

  PlayerModel copyWith({
    bool? isPlaying,
    bool? isFinished,
    String? statusText,
    String? recordedFilePath,
  }) {
    return PlayerModel(
      isPlaying: isPlaying ?? this.isPlaying,
      isFinished: isFinished ?? this.isFinished,
      statusText: statusText ?? this.statusText,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
    );
  }
}
