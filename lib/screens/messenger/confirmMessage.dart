import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/messengerInfo.dart';
import 'package:client/model/scheduleInfo.dart';
import 'package:client/screens/record/controller.dart';
import 'package:client/screens/record/viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ConfirmMessage extends ConsumerWidget {
  const ConfirmMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = GoRouterState.of(context).extra as MessengerInfo;
    final recorderController = ref.read(recorderControllerProvider);

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Bold_36px(
            text: "[  ]라고\n전송할까요?",
            color: CareConnectColor.white,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.go('/contact/messenger', extra: info),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CareConnectColor.primary[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Bold_26px(
                          text: "전송",
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
                      ref
                          .read(recorderViewModelProvider.notifier)
                          .resetAll(recorderController);
                      context.go('/contact/messenger/enroll', extra: info);
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CareConnectColor.primary[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Bold_26px(
                          text: "다시 녹음",
                          color: CareConnectColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
