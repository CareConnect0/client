import 'package:client/api/Assistant/assistant_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTextFormField.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/designs/MyMessageBubble.dart';
import 'package:client/designs/OtherMessageBubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AIChat extends ConsumerWidget {
  AIChat({super.key});

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
    final chatState = ref.watch(assistantViewModelProvider);
    final viewModel = ref.read(assistantViewModelProvider.notifier);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(
          text: "AI 대화 도우미",
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: Column(
              children: [
                // 메세지 표시 영역
                // Expanded(
                //   child: ListView.builder(
                //     reverse: true,
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     itemCount: messages.length,
                //     itemBuilder: (context, index) {
                //       final reversedMessages = messages.reversed.toList();
                //       final msg = reversedMessages[index];
                //       return Padding(
                //         padding: const EdgeInsets.only(top: 28),
                //         child: msg["isMe"]
                //             ? MyMessageBubble(
                //                 message: msg["text"], time: msg["time"])
                //             : OtherMessageBubble(
                //                 message: msg["text"],
                //                 time: msg["time"],
                //                 assetUrl: 'assets/icons/message-smile.svg',
                //               ),
                //       );
                //     },
                //   ),
                // ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scroll) {
                      if (scroll.metrics.pixels ==
                              scroll.metrics.maxScrollExtent &&
                          chatState.hasNext) {
                        viewModel.loadMoreMessages();
                      }
                      return false;
                    },
                    child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: chatState.messages.length,
                      itemBuilder: (context, index) {
                        final reversed = chatState.messages.reversed.toList();
                        final msg = reversed[index];
                        final isMe = msg.senderType == "USER";

                        return Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: isMe
                              ? MyMessageBubble(
                                  message: msg.content, time: msg.sentAt)
                              : OtherMessageBubble(
                                  message: msg.content,
                                  time: msg.sentAt,
                                  assetUrl: 'assets/icons/message-smile.svg',
                                ),
                        );
                      },
                    ),
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
                          context.go('/ai/enroll');
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
          if (!isKeyboardOpen)
            Positioned(
              bottom: 120,
              child: InkWell(
                onTap: () => context.go('/home'),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CareConnectColor.primary[900],
                    boxShadow: [
                      BoxShadow(
                        color: CareConnectColor.black.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/home.svg',
                        color: CareConnectColor.white,
                      ),
                      Semibold_16px(
                        text: "홈 화면",
                        color: CareConnectColor.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
