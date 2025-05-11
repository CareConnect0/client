import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/screens/emergency_player/controller.dart';
import 'package:client/screens/emergency_player/model.dart';
import 'package:client/screens/emergency_player/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

final playerControllerProvider = Provider<RecordPlayerController>((ref) {
  return RecordPlayerController();
});

final playerViewModelProvider = NotifierProvider<PlayerViewModel, PlayerModel>(
  () => PlayerViewModel(),
);

class EmergencyPlayer extends ConsumerStatefulWidget {
  const EmergencyPlayer({super.key});

  @override
  ConsumerState<EmergencyPlayer> createState() => _EmergencyPlayerState();
}

class _EmergencyPlayerState extends ConsumerState<EmergencyPlayer> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // 한 번만 초기화하도록 플래그 사용
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_initialized) {
        _initialized = true;
        _initializePlayer();
      }
    });
  }

  Future<void> _initializePlayer() async {
    try {
      print("🔄 Initializing player...");
      final audioPath = await loadAssetAudioToFile('assets/example.wav');
      print("📂 Audio path: $audioPath");
      await ref.read(playerViewModelProvider.notifier).initialize(audioPath);
    } catch (e) {
      print("🚨 Error initializing player: $e");
      ref.read(playerViewModelProvider.notifier).handleError("오류가 발생했습니다");
    }
  }

  @override
  void dispose() {
    print("📤 Disposing EmergencyPlayer");
    ref.read(playerViewModelProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerViewModelProvider);
    final viewModelNotifier = ref.read(playerViewModelProvider.notifier);
    final playerController = ref.read(playerControllerProvider);

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Row(
            children: [
              const SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              const SizedBox(width: 8),
              Semibold_16px(
                text: "뒤로가기",
                color: CareConnectColor.white,
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 웨이브폼 표시
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width, 100),
              playerController: playerController.playerController,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: CareConnectColor.neutral[400]!,
                liveWaveColor: CareConnectColor.neutral[500]!,
                spacing: 6,
              ),
            ),
            SizedBox(height: 60),

            // 상태 텍스트
            Bold_30px(
              text: playerState.statusText,
              color: CareConnectColor.white,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),

            if (playerState.isPlaying) ...[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ],

            // 재생 종료 후 버튼 표시
            if (playerState.isFinished) ...[
              Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => viewModelNotifier.replay(),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: CareConnectColor.primary[900],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Bold_26px(
                              text: "예",
                              color: CareConnectColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: CareConnectColor.primary[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Bold_26px(
                              text: "아니오",
                              color: CareConnectColor.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
