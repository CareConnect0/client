import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmSchedule extends StatelessWidget {
  const ConfirmSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Bold_36px(
            text: "n월 nn일\nnn시nn분에\n[  ]\n일정을 등록할까요?",
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
                    onTap: () => '/calendar',
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: CareConnectColor.primary[900],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Bold_26px(
                          text: "등록",
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
                    onTap: () => context.go('/calendar/enroll'),
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
