import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CareConnectDialog2 extends ConsumerWidget {
  final String titleText;
  final String contentText;
  final VoidCallback done;

  CareConnectDialog2({
    required this.titleText,
    required this.contentText,
    required this.done,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      backgroundColor: CareConnectColor.white,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 34, horizontal: 34),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Bold_20px(
              text: titleText,
              color: CareConnectColor.black,
            ),
            SizedBox(
              height: 12,
            ),
            Medium_16px(
              text: contentText,
              color: CareConnectColor.neutral[500],
            ),
            SizedBox(
              height: 33,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: done,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: CareConnectColor.white,
                          border: Border.all(
                              color: CareConnectColor.neutral[400]!, width: 1)),
                      child: Center(
                        child: Semibold_16px(
                          text: "네",
                          color: CareConnectColor.neutral[600],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CareConnectColor.neutral[600],
                      ),
                      child: Center(
                        child: Semibold_16px(
                          text: "아니요",
                          color: CareConnectColor.white,
                        ),
                      ),
                    ),
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
