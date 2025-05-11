import 'dart:async';
import 'dart:io';

import 'package:client/screens/emergency_player/controller.dart';
import 'package:client/screens/emergency_player/model.dart';
import 'package:client/screens/emergency_player/view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class PlayerViewModel extends Notifier<PlayerModel> {
  late RecordPlayerController _playerController;
  Timer? _completionTimer;

  @override
  PlayerModel build() {
    _playerController = ref.read(playerControllerProvider);
    return PlayerModel(
      isPlaying: false,
      isFinished: false,
      statusText: "녹음 확인 중...",
    );
  }

  Future<void> initialize(String filePath) async {
    // print("Initializing player with file: $filePath");
    try {
      // 파일 존재 확인
      final file = File(filePath);
      if (!await file.exists()) {
        // print("🚨 Audio file does not exist at path: $filePath");
        state = state.copyWith(
          statusText: "오디오 파일을 찾을 수 없습니다",
          isPlaying: false,
          isFinished: true,
        );
        return;
      }

      // print("Audio file exists and has size: ${await file.length()} bytes");

      // 플레이어 준비
      await _playerController.preparePlayer(filePath);

      // 상태 업데이트
      state = state.copyWith(
        recordedFilePath: filePath,
        isPlaying: true,
        isFinished: false,
        statusText: "녹음 확인 중...",
      );

      // 재생 완료 콜백 설정
      _playerController.onCompletion = () {
        // print("onCompletion callback triggered");
        state = state.copyWith(
          isPlaying: false,
          isFinished: true,
          statusText: "다시 들으시겠습니까?",
        );
      };

      // 플레이어 시작
      // print("Starting player...");
      await _playerController.startPlayer();

      // 백업 타이머: 오디오 재생 시간을 확인하여 완료 여부 판단
      _setupCompletionTimer();
    } catch (e) {
      // print("🚨 Error in initialize: $e");
      state = state.copyWith(
        statusText: "오디오 재생 중 오류가 발생했습니다",
        isPlaying: false,
        isFinished: true,
      );
    }
  }

  // 재생 완료를 백업으로 감지하기 위한 타이머 설정
  Future<void> _setupCompletionTimer() async {
    try {
      // 먼저 기존 타이머가 있으면 취소
      _completionTimer?.cancel();

      // 오디오 파일의 길이를 가져옴
      final durationMs = await _playerController.totalDuration;
      // print("Setting up completion timer for ${durationMs.inMilliseconds}ms");

      if (durationMs.inMilliseconds > 0) {
        // 파일 길이 + 여유 시간 후에 완료 상태로 변경
        _completionTimer = Timer(durationMs + const Duration(seconds: 1), () {
          if (state.isPlaying) {
            // print("Completion timer triggered - marking playback as complete");
            state = state.copyWith(
              isPlaying: false,
              isFinished: true,
              statusText: "다시 들으시겠습니까?",
            );
          }
        });
      }
    } catch (e) {
      print("Error setting up completion timer: $e");
    }
  }

  // 오류 처리 메소드 추가
  void handleError(String message) {
    state = state.copyWith(
      isPlaying: false,
      isFinished: true,
      statusText: message,
    );
  }

  void replay() async {
    if (state.recordedFilePath != null) {
      try {
        // 타이머 취소
        _completionTimer?.cancel();

        state = state.copyWith(
          isPlaying: true,
          isFinished: false,
          statusText: "녹음 확인 중...",
        );
        await _playerController.seekTo(0);
        await _playerController.startPlayer();

        // 새로운 완료 타이머 설정
        _setupCompletionTimer();
      } catch (e) {
        print("🚨 Error in replay: $e");
        state = state.copyWith(
          statusText: "다시 재생 중 오류가 발생했습니다",
          isPlaying: false,
          isFinished: true,
        );
      }
    }
  }

  void dispose() {
    _completionTimer?.cancel();
    _playerController.dispose();
  }
}

Future<String> loadAssetAudioToFile(String assetPath) async {
  try {
    // print("Loading asset audio: $assetPath");
    final byteData = await rootBundle.load(assetPath);
    // print("Asset loaded with size: ${byteData.lengthInBytes} bytes");

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/temp_audio.wav');

    await file.writeAsBytes(byteData.buffer.asUint8List());
    // print("Audio file written to: ${file.path}");

    // 파일 존재 확인
    if (await file.exists()) {
      // print("File exists and has size: ${await file.length()} bytes");
    } else {
      // print("🚨 File was not created properly!");
    }

    return file.path;
  } catch (e) {
    // print("🚨 Error loading asset audio: $e");
    rethrow;
  }
}
