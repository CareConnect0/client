import 'package:client/designs/CareConnectColor.dart';
import 'package:client/screens/record/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/screens/record/controller.dart';

class CustomRecordingWaveWidget extends ConsumerWidget {
  const CustomRecordingWaveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = ref.watch(recorderVolumeProvider);
    return WaveformWidget(currentVolume: volume);
  }
}

class WaveformWidget extends ConsumerWidget {
  final double currentVolume;

  const WaveformWidget({super.key, required this.currentVolume});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.watch(recorderControllerProvider);

    return AudioWaveforms(
      size: Size(MediaQuery.of(context).size.width, 100),
      recorderController: recorderController,
      waveStyle: WaveStyle(
        showMiddleLine: false,
        waveColor: CareConnectColor.neutral[400]!,
        extendWaveform: true,
      ),
    );
  }
}
