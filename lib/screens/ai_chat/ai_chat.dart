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
import 'package:intl/intl.dart';

class AIChat extends ConsumerStatefulWidget {
  const AIChat({super.key});

  @override
  ConsumerState<AIChat> createState() => _AIChatState();
}

class _AIChatState extends ConsumerState<AIChat> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AIChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollToBottom(); // 위젯 업데이트 시에도 스크롤
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0, // reverse: true라서 0.0이 bottom
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(assistantViewModelProvider);
    final viewModel = ref.read(assistantViewModelProvider.notifier);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // 새 메시지 오면 자동 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "AI 대화 도우미", color: CareConnectColor.white),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            ref.read(assistantRepositoryProvider).disconnectSocket();
            context.go('/home');
          },
          child: Row(
            children: [
              SizedBox(width: 20),
              SizedBox(
                width: 6,
                height: 12,
                child: SvgPicture.asset('assets/icons/chevron-left.svg'),
              ),
              SizedBox(width: 8),
              Semibold_16px(text: "뒤로가기", color: CareConnectColor.white),
            ],
          ),
        ),
        shape: Border(
          bottom: BorderSide(color: CareConnectColor.neutral[200]!, width: 1),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            child: Column(
              children: [
                // 메세지 표시 영역
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
                        final msg = chatState.messages.toList()[index];
                        final isMe = msg.senderType == "USER";

                        String formatSentAt(String isoString) {
                          final dateTime = DateTime.parse(isoString);
                          final datePart = DateFormat(
                            'yyyy.MM.dd',
                          ).format(dateTime);
                          final timePart = DateFormat(
                            'a h:mm',
                            'ko',
                          ).format(dateTime); // 'a'는 오전/오후
                          return '$timePart';
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child:
                              isMe
                                  ? MyMessageBubble(
                                    message: msg.content,
                                    time: formatSentAt(msg.sentAt),
                                  )
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
                      Expanded(child: CareConnectTextFormField(isAI: true)),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          context.push('/ai/enroll');
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
              ],
            ),
          ),
          if (!isKeyboardOpen)
            Positioned(
              bottom: 120,
              child: InkWell(
                onTap: () {
                  ref.read(assistantRepositoryProvider).disconnectSocket();
                  context.go('/home');
                },
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
