import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recorderControllerProvider = Provider<RecorderController>((ref) {
  final controller = RecorderController();
  controller.updateFrequency = const Duration(milliseconds: 50);
  return controller;
});
