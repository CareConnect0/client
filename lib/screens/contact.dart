import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class Contact extends ConsumerWidget {
  const Contact({super.key});

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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: CareConnectColor.primary[900],
                  ),
                  child: Center(
                    child: Bold_20px(
                      text: "누구에게 연락할까요?",
                      color: CareConnectColor.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                Expanded(child: PersonCard(ref)),
              ],
            ),
          ),
          IgnorePointer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.topCenter,
                  begin: Alignment.bottomCenter,
                  colors: [
                    CareConnectColor.neutral[700]!.withOpacity(1),
                    CareConnectColor.neutral[700]!.withOpacity(0.3),
                    CareConnectColor.neutral[700]!.withOpacity(0),
                    CareConnectColor.neutral[700]!.withOpacity(0),
                    CareConnectColor.neutral[700]!.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
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

  Widget PersonCard(WidgetRef ref) {
    return ListView.separated(
      itemCount: 3,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 36),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: CareConnectColor.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    width: 114,
                    height: 114,
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
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CareConnectColor.secondary[300],
                          boxShadow: [
                            BoxShadow(
                              color: CareConnectColor.black.withOpacity(0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 0),
                            ),
                          ]),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Bold_20px(text: "이름"),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: CareConnectColor.primary[200],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: CareConnectColor.primary[900]!, width: 1),
                ),
                child: Center(
                  child: Medium_16px(
                    text: "문자 보내기",
                    color: CareConnectColor.neutral[800],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
