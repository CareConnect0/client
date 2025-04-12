import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            colorFilter: ColorFilter.mode(
                CareConnectColor.black.withOpacity(0.65), BlendMode.srcOver),
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/logo.svg"),
            SizedBox(
              height: 15,
            ),
            Semibold_28px(
              text: "함께하루",
              color: CareConnectColor.primary[900],
            ),
            SizedBox(
              height: 75,
            ),
            InkWell(
              onTap: () {
                context.go('/signIn');
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 51),
                padding: EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CareConnectColor.primary[900],
                ),
                child: Center(
                  child: Bold_22px(
                    text: "로그인",
                    color: CareConnectColor.neutral[50],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Medium_16px(
              text: "아직 회원이 아니신가요?",
              color: CareConnectColor.neutral[50],
            ),
            SizedBox(
              height: 11,
            ),
            InkWell(
              onTap: () {
                context.go('/signUp');
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 51),
                padding: EdgeInsets.symmetric(vertical: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CareConnectColor.primary[200],
                ),
                child: Center(
                  child: Bold_22px(
                    text: "회원가입",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
