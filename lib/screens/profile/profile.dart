import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectDialog2.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/Auth/auth_repository.dart';
import 'package:client/Auth/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Profile extends ConsumerWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.primary[900],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(
          text: "마이페이지",
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
      body: Column(
        children: [
          Myprofile(),
          OptionCard1(context, "비밀번호 변경", '/profile/password'),
          OptionCard1(context, "이용약관", '/profile/terms'),
          OptionCard2(
            context,
            "로그아웃",
            "로그아웃하시겠습니까?",
            "로그아웃해도 정보가 사라지지 않습니다.",
            () async {
              await AuthRepository().logout();
              context.go('/');
            },
          ),
          OptionCard2(
            context,
            "회원탈퇴",
            "회원을 탈퇴하시겠습니까?",
            "회원탈퇴 시, 모든 정보가 사라집니다.",
            () async {
              await AuthStorage.clear();
              // TODO: 탈퇴로직 추가
            },
          ),
        ],
      ),
    );
  }

  Widget Myprofile() {
    return Container(
      color: CareConnectColor.primary[50],
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: CareConnectColor.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: CareConnectColor.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/example.png"),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Bold_24px(text: "사용자님"),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: CareConnectColor.primary[200],
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: CareConnectColor.primary[900]!, width: 1),
              ),
              child: Center(child: Medium_18px(text: "프로필 수정")),
            ),
          ],
        ),
      ),
    );
  }

  Widget OptionCard1(BuildContext context, text, done) {
    return InkWell(
      onTap: () {
        context.push(done);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          children: [
            Medium_20px(text: text),
            Spacer(),
            SvgPicture.asset('assets/icons/chevron-right.svg'),
          ],
        ),
      ),
    );
  }

  Widget OptionCard2(
    BuildContext context,
    text,
    titleText,
    contentText,
    Future<void> Function() route,
  ) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CareConnectDialog2(
            titleText: titleText,
            contentText: contentText,
            done: () async {
              context.pop();
              await route();
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: CareConnectColor.neutral[900],
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }
}
