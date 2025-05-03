import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Messenger extends ConsumerWidget {
  const Messenger({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(
          text: "메신저",
          color: CareConnectColor.white,
        ),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              SizedBox(
                width: 8,
              ),
              Semibold_16px(
                text: "뒤로가기",
                color: CareConnectColor.white,
              )
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: CareConnectColor.neutral[200]!,
            width: 1,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        child: Column(
          children: [
            // 메세지 표시 영역
            OtherMessageBubble(),
            SizedBox(
              height: 20,
            ),
            MyMessageBubble(
                message: "Bibendum dictum quisque id aliquam.",
                time: "오후 3:14"),
            // 메세지 입력 영역
          ],
        ),
      ),
    );
  }
}

class OtherMessageBubble extends ConsumerWidget {
  const OtherMessageBubble({super.key});

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
                image: const DecorationImage(
                  image: AssetImage('assets/images/example.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CareConnectColor.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semibold_16px(
                  text: "이름",
                  color: CareConnectColor.white,
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CareConnectColor.primary[400],
                  ),
                  child: Medium_16px(
                      text: "Lorem ipsum dolor sit amet consectetur. "),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          width: 8,
        ),
        Semibold_11px(
          text: "오후 3:14",
          color: CareConnectColor.white,
        ),
      ],
    );
  }
}

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
        Stack(children: [
          SvgPicture.asset("assets/icons/chat-bubble.svg"),
          Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 32),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            color: Colors.transparent,
            child: Medium_16px(
              text: message,
              color: CareConnectColor.white,
            ),
          ),
        ]),
      ],
    );
  }
}
