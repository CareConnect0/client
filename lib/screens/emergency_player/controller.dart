import 'package:audio_waveforms/audio_waveforms.dart';

class RecordPlayerController {
  final PlayerController _playerController = PlayerController();
  Function? onCompletion;
  bool _isListening = false;

  Future<void> preparePlayer(String path) async {
    // print("Preparing player with file: $path");
    try {
      await _playerController.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: 100,
      );
      // print("Player prepared successfully.");

      // 플레이어 상태 리스너가 중복 등록되지 않도록 체크
      if (!_isListening) {
        _isListening = true;

        // 재생 상태 리스너 등록 - 재생 완료 감지를 위해 사용
        _playerController.onPlayerStateChanged.listen((state) {
          // print('💡 playerState: $state');
          if (state == PlayerState.playing) {
            // print('🎧 Audio is playing!');
          } else if (state == PlayerState.paused ||
              state == PlayerState.stopped) {
            // print('⏸️ Audio is paused or stopped');

            // 재생이 완료된 경우 현재 위치와 총 길이를 비교하여 확인
            _checkIfPlaybackCompleted();
          }
        });
      }
    } catch (e) {
      // print("🚨 Error preparing player: $e");
    }
  }

  // 재생 완료 여부를 확인하는 메소드
  Future<void> _checkIfPlaybackCompleted() async {
    try {
      final currentPos =
          await _playerController.getDuration(DurationType.current);
      final maxPos = await _playerController.getDuration(DurationType.max);

      // print("Current position: $currentPos, Max position: $maxPos");

      // 현재 위치가 최대 길이의 90% 이상이면 재생 완료로 간주
      if (maxPos > 0 && currentPos >= maxPos * 0.9) {
        // print("🎵 Playback considered complete based on position");
        if (onCompletion != null) {
          onCompletion!();
        }
      }
    } catch (e) {
      // print("Error checking playback completion: $e");
    }
  }

  Future<void> startPlayer() async {
    try {
      // print("Starting player...");
      // audio_waveforms 1.3.0에서는 finishMode와 whenFinished가 없음
      await _playerController.startPlayer();
      // print("Player started successfully");

      // 재생 완료를 감지하기 위한 타이머 설정
      final duration = await totalDuration;
      if (duration.inMilliseconds > 0) {
        Future.delayed(duration + const Duration(milliseconds: 500), () {
          _checkIfPlaybackCompleted();
        });
      }
    } catch (e) {
      // print("🚨 Error starting player: $e");
    }
  }

  Future<void> pausePlayer() async {
    try {
      await _playerController.pausePlayer();
    } catch (e) {
      print("🚨 Error pausing player: $e");
    }
  }

  Future<void> stopPlayer() async {
    try {
      await _playerController.stopPlayer();
    } catch (e) {
      print("🚨 Error stopping player: $e");
    }
  }

  Future<void> seekTo(int milliseconds) async {
    try {
      await _playerController.seekTo(milliseconds);
    } catch (e) {
      print("🚨 Error seeking: $e");
    }
  }

  Future<void> dispose() async {
    try {
      _playerController.dispose();
    } catch (e) {
      print("🚨 Error disposing player: $e");
    }
  }

  // 현재 재생 위치 가져오기
  Future<Duration> get currentPosition async {
    final positionMs =
        await _playerController.getDuration(DurationType.current);
    return Duration(milliseconds: positionMs);
  }

  // 전체 재생 길이 가져오기
  Future<Duration> get totalDuration async {
    final durationMs = await _playerController.getDuration(DurationType.max);
    return Duration(milliseconds: durationMs);
  }

  PlayerController get playerController => _playerController;
  PlayerState? get playerState => _playerController.playerState;
}
