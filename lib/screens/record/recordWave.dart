import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/screens/record/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingWave extends ConsumerWidget {
  const RecordingWave({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.watch(recorderControllerProvider);

    return AudioWaveforms(
      enableGesture: false,
      size: Size(MediaQuery.of(context).size.width, 80.0),
      recorderController: recorderController,
      waveStyle: const WaveStyle(
        waveColor: Colors.blueAccent,
        extendWaveform: true,
        showMiddleLine: false,
      ),
      decoration: const BoxDecoration(color: Colors.transparent),
    );
  }
}
