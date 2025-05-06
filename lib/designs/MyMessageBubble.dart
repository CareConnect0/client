import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class MyMessageBubble extends ConsumerWidget {
  final String message;
  final String time;

  const MyMessageBubble({required this.message, required this.time, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Semibold_11px(text: time, color: CareConnectColor.white),
        const SizedBox(width: 8),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 20, right: 32),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                color: CareConnectColor.neutral[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Medium_16px(
                text: message,
                color: CareConnectColor.white,
              ),
            ),
            Positioned(
                top: 20,
                child:
                    SvgPicture.asset("assets/icons/chat-bubble-polygon.svg")),
          ],
        )
      ],
    );
  }
}
