import 'dart:async';
import 'dart:math';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/screens/record/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

final recorderViewModelProvider =
    NotifierProvider<RecorderViewModel, RecorderModel>(
  () => RecorderViewModel(),
);

final recorderVolumeProvider = StateProvider<double>((ref) => 0.0);

class RecorderViewModel extends Notifier<RecorderModel> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription? _recorderSubscription;

  @override
  RecorderModel build() {
    _initRecorder();
    return RecorderModel(isRecording: false, statusText: "버튼을 누르고\n가까이서 말해주세요");
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) throw Exception("🎤 마이크 권한이 필요합니다.");
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    print("🎤 녹음기 초기화 완료");
  }

  Future<void> toggleRecording(RecorderController controller) async {
    if (state.isRecording) {
      _recorderSubscription?.cancel();
      _recorderSubscription = null;

      final path = await _recorder.stopRecorder();
      controller.reset();

      state = state.copyWith(
        isRecording: false,
        statusText: "녹음 완료!",
        recordedFilePath: path,
        readyForNavigation: true,
      );
      ref.read(recorderVolumeProvider.notifier).state = 0.0;
    } else {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/speech_${DateTime.now().millisecondsSinceEpoch}.wav';

      _recorderSubscription = _recorder.onProgress!.listen((e) {
        final db = e.decibels ?? 0.0;
        double normalized = ((db + 60) / 60).clamp(0.0, 1.0);
        normalized = pow(normalized, 0.5).toDouble();
        ref.read(recorderVolumeProvider.notifier).state = normalized;
      });

      await _recorder.startRecorder(toFile: path, codec: Codec.pcm16WAV);
      controller.record();

      state = state.copyWith(
        isRecording: true,
        statusText: "말하는 중 ...",
        recordedFilePath: path,
        readyForNavigation: false,
      );
    }
  }

  void resetNavigation() {
    state = state.copyWith(readyForNavigation: false);
  }
}
