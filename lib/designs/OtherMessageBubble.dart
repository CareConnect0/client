import 'package:client/api/ai/ai_repository.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class OtherMessageBubble extends ConsumerWidget {
  final String message;
  final String time;
  final String name;
  final String imageUrl;
  final String assetUrl;
  const OtherMessageBubble({
    required this.message,
    required this.time,
    this.name = '',
    this.assetUrl = '',
    this.imageUrl = '',
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CareConnectColor.white,
                image:
                    assetUrl.isEmpty
                        ? DecorationImage(
                          image:
                              imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/example.png'),
                          fit: BoxFit.cover,
                        )
                        : null,
                boxShadow: [
                  BoxShadow(
                    color: CareConnectColor.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child:
                  assetUrl.isNotEmpty
                      ? Center(child: SvgPicture.asset(assetUrl))
                      : null,
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name.isNotEmpty
                    ? Semibold_16px(text: name, color: CareConnectColor.white)
                    : SizedBox(),
                name.isNotEmpty ? SizedBox(height: 8) : SizedBox(),
                InkWell(
                  onTap: () async {
                    final tts = AIRepository();
                    await tts.playTTS(message);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.55,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: CareConnectColor.primary[400],
                    ),
                    child: Medium_16px(text: message),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 8),
        Semibold_11px(text: time, color: CareConnectColor.white),
      ],
    );
  }
}
