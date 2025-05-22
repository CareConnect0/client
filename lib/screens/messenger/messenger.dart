import 'package:client/api/Chatting/chatting_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTextFormField.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/designs/MyMessageBubble.dart';
import 'package:client/designs/OtherMessageBubble.dart';
import 'package:client/model/availableUser.dart';
import 'package:client/model/chatMessage.dart';
import 'package:client/model/messengerInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Messenger extends ConsumerStatefulWidget {
  final AvailableUser user;
  const Messenger(this.user, {super.key});

  @override
  ConsumerState<Messenger> createState() => _MessengerState();
}

class _MessengerState extends ConsumerState<Messenger> {
  late final ScrollController _scrollController;
  int? roomId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    initRoomAndMessages();
  }

  Future<void> initRoomAndMessages() async {
    final id = await ref
        .read(chattingViewModelProvider.notifier)
        .getRoomId(widget.user.userId);
    setState(() => roomId = id);

    // 특정 채팅방 소켓 구독
    ref.read(chattingRepositoryProvider).subscribeToRoom(id, (msg) {
      print('실시간 메시지: ${msg['content']}');
      print('msg: $msg');

      final message = ChatMessage.fromJson(msg);
      ref.read(messengerViewModelProvider(id).notifier).addMessage(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (roomId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final messagesState = ref.watch(messengerViewModelProvider(roomId!));
    final vm = ref.read(messengerViewModelProvider(roomId!).notifier);

    return Scaffold(
      backgroundColor: CareConnectColor.neutral[700],
      appBar: AppBar(
        backgroundColor: CareConnectColor.neutral[700],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "메신저", color: CareConnectColor.white),
        centerTitle: true,
        leadingWidth: 97,
        leading: InkWell(
          onTap: () {
            context.pop();
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
      body: messagesState.when(
        data: (messages) {
          return Column(
            children: [
              // 메세지 표시 영역
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scroll) {
                    if (scroll.metrics.pixels ==
                        scroll.metrics.maxScrollExtent) {
                      vm.loadMoreMessages();
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId != widget.user.userId;

                      return Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child:
                            isMe
                                ? MyMessageBubble(
                                  message: msg.content,
                                  time: formatTime(msg.sentAt),
                                )
                                : OtherMessageBubble(
                                  message: msg.content,
                                  time: formatTime(msg.sentAt),
                                  name: msg.senderName,
                                  imageUrl: 'assets/images/example.png',
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
                    Expanded(child: CareConnectTextFormField(roomId: roomId!)),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        final messengerInfo = MessengerInfo(
                          roomId: roomId!,
                          person: widget.user.name,
                        );

                        context.push(
                          '/contact/messenger/enroll',
                          extra: messengerInfo,
                        );
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
              SizedBox(height: 34),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러: $e')),
      ),
    );
  }

  String formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? '오후' : '오전';
    return '$ampm $hour:${dt.minute.toString().padLeft(2, '0')}';
  }
}
