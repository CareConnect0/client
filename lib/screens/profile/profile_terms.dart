import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileTerms extends StatelessWidget {
  const ProfileTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.primary[900],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(
          text: "이용약관",
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
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semibold_20px(text: "이용 약관"),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CareConnectColor.neutral[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Medium_14px(
                    text:
                        "Lorem ipsum dolor sit amet consectetur. Donec nec sed nunc turpis. A vitae vulputate diam morbi commodo ultrices in. Vitae cursus fermentum in tristique ullamcorper egestas leo aliquam fringilla. Convallis suscipit tincidunt pharetra morbi sit ut mauris. Feugiat fusce proin aliquam at id vestibulum sed. Sed arcu quis nulla... ",
                    color: CareConnectColor.neutral[500],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "전문 보기",
                    style: TextStyle(
                      color: CareConnectColor.neutral[900],
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Semibold_20px(text: "서비스 이용 약관"),
            SizedBox(
              height: 8,
            ),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CareConnectColor.neutral[100],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Medium_14px(
                    text:
                        "Lorem ipsum dolor sit amet consectetur. Donec nec sed nunc turpis. A vitae vulputate diam morbi commodo ultrices in. Vitae cursus fermentum in tristique ullamcorper egestas leo aliquam fringilla. Convallis suscipit tincidunt pharetra morbi sit ut mauris. Feugiat fusce proin aliquam at id vestibulum sed. Sed arcu quis nulla... ",
                    color: CareConnectColor.neutral[500],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    "전문 보기",
                    style: TextStyle(
                      color: CareConnectColor.neutral[900],
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.clip,
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
