import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/model/emergencyItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyNotification extends ConsumerWidget {
  final EmergencyItem emergency;
  final String dependentName;
  final String dependentPhoneNumber;
  const EmergencyNotification(
    this.emergency,
    this.dependentName,
    this.dependentPhoneNumber, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.white),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icons/emergency-notification.svg"),
            SizedBox(height: 8),
            Bold_22px(
              text:
                  '${DateFormat('MM월 dd일\nHH시 mm분').format(emergency.createdAt)}에\n$dependentName님이 긴급 호출 버튼을\n누르셨습니다.',
              color: CareConnectColor.white,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36),
            Bold_20px(text: "현재 위치 : 위치 없음", color: CareConnectColor.white),
            Bold_20px(
              text:
                  "인식된 음성 : ${emergency.keyword!.isNotEmpty ? emergency.keyword!.join(', ') : '음성 없음'}",
              color: CareConnectColor.white,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (emergency.keyword!.isNotEmpty)
                          context.push('/emergency/record');
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color:
                              emergency.keyword!.isNotEmpty
                                  ? CareConnectColor.primary[900]
                                  : CareConnectColor.neutral[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Bold_26px(
                            text: "녹음듣기",
                            color: CareConnectColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final url = Uri.parse('tel:$dependentPhoneNumber');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: CareConnectColor.primary[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Bold_26px(
                            text: "전화하기",
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
      ),
    );
  }
}
