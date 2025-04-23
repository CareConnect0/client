import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CareConnectDialog extends ConsumerWidget {
  final String time;
  final String scheduleText;
  final TextEditingController scheduleController;
  final VoidCallback cancel;
  final VoidCallback modify;
  final VoidCallback delete;

  CareConnectDialog({
    required this.time,
    required this.scheduleText,
    required this.scheduleController,
    required this.cancel,
    required this.modify,
    required this.delete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: CareConnectColor.neutral[100],
      surfaceTintColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      content: SizedBox(
        width: 349,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Medium_26px(
                    text: time,
                    color: CareConnectColor.black,
                  ),
                ),
                InkWell(
                  onTap: cancel,
                  child: Semibold_18px(
                    text: '닫기',
                    color: CareConnectColor.primary[900],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: CareConnectColor.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 4,
                    color: CareConnectColor.black.withOpacity(0.25),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset('assets/icons/person.svg'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: scheduleController,
                      maxLines: null, // 여러 줄 입력 가능
                      style: TextStyle(
                        fontSize: 20,
                        color: CareConnectColor.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                      ),
                      decoration: InputDecoration(
                        hintText: '일정 내용을 입력해주세요',
                        hintStyle: TextStyle(
                          color: CareConnectColor.neutral[400],
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: modify,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/edit.svg',
                        color: CareConnectColor.primary[900],
                      ),
                      Semibold_18px(
                        text: '수정하기',
                        color: CareConnectColor.primary[900],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                InkWell(
                  onTap: delete,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/x-close.svg',
                        color: CareConnectColor.neutral[500],
                      ),
                      Semibold_18px(
                        text: '삭제하기',
                        color: CareConnectColor.neutral[500],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
