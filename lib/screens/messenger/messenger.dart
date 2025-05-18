import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTextFormField.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/designs/MyMessageBubble.dart';
import 'package:client/designs/OtherMessageBubble.dart';
import 'package:client/model/availableUser.dart';
import 'package:client/model/messengerInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Messenger extends ConsumerWidget {
  final AvailableUser targetId;
  Messenger(this.targetId, {super.key});

  final List<Map<String, dynamic>> messages = [
    {"text": "안녕하세요!", "isMe": false, "time": "오후 3:10"},
    {"text": "안녕하세요~", "isMe": true, "time": "오후 3:11"},
    {"text": "어디 계세요?", "isMe": false, "time": "오후 3:12"},
    {
      "text":
          "조금 늦을 것 같아요!조금 늦을 것 같아요!조금 늦을 것 같아요!조금 늦을 것 같아요!조금 늦을 것 같아요!조금 늦을 것 같아요!",
      "isMe": true,
      "time": "오후 3:13"
    },
    {"text": "안녕하세요!", "isMe": false, "time": "오후 3:10"},
    {"text": "안녕하세요~", "isMe": true, "time": "오후 3:11"},
    {"text": "어디 계세요?", "isMe": false, "time": "오후 3:12"},
    {"text": "조금 늦을 것 같아요!", "isMe": true, "time": "오후 3:13"},
    {"text": "안녕하세요!", "isMe": false, "time": "오후 3:10"},
    {"text": "안녕하세요~", "isMe": true, "time": "오후 3:11"},
    {"text": "어디 계세요?", "isMe": false, "time": "오후 3:12"},
    {"text": "조금 늦을 것 같아요!", "isMe": true, "time": "오후 3:13"},
  ];

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
        child: Column(
          children: [
            // 메세지 표시 영역
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final reversedMessages = messages.reversed.toList();
                  final msg = reversedMessages[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 28),
                    child: msg["isMe"]
                        ? MyMessageBubble(
                            message: msg["text"], time: msg["time"])
                        : OtherMessageBubble(
                            message: msg["text"],
                            time: msg["time"],
                            name: "이름",
                            imageUrl: 'assets/images/example.png',
                          ),
                  );
                },
              ),
            ),
            // 메세지 입력 영역
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 70,
              child: Row(
                children: [
                  Expanded(child: CareConnectTextFormField()),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: () {
                      final info = MessengerInfo(person: 'example');

                      context.go('/contact/messenger/enroll', extra: info);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: CareConnectColor.white,
                        ),
                      ),
                      child: Container(
                        width: 31,
                        height: 31,
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CareConnectColor.secondary[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 34,
            ),
          ],
        ),
      ),
    );
  }
}
