import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfileTerms extends StatelessWidget {
  const ProfileTerms({super.key});

  final terms = """
함께하루 이용약관
본 약관은 함께하루(이하 “서비스”)를 제공하는 운영자와 서비스 이용자 간의 권리와 의무, 책임사항, 기타 필요한 사항을 규정합니다.

제1조 (목적)
이 약관은 함께하루 서비스를 이용함에 있어 필요한 기본적인 사항을 규정함을 목적으로 합니다.

제2조 (정의)
서비스: 보호자와 피보호자가 소통하고 일정을 공유하며 안전을 확인할 수 있도록 지원하는 모바일 앱

이용자: 본 약관에 동의하고 서비스를 사용하는 피보호자 및 보호자

운영자: 본 서비스를 기획, 제공 및 운영하는 단체 또는 개인

제3조 (약관의 효력 및 변경)
본 약관은 이용자가 동의한 시점부터 효력을 갖습니다.

운영자는 필요한 경우 약관을 변경할 수 있으며, 변경 시 사전 공지를 통해 효력을 가집니다.

변경된 약관에 동의하지 않을 경우 이용자는 서비스 이용을 중단하고 탈퇴할 수 있습니다.

제4조 (서비스 제공 및 변경)
함께하루는 다음 기능을 포함한 서비스를 제공합니다:

일정 공유, 음성 메모, 채팅, 비상 호출, 푸시 알림

서비스는 연중무휴로 제공되며, 시스템 유지보수 등으로 일시 중단될 수 있습니다.

제5조 (이용자의 의무)
이용자는 다음 행위를 하지 않아야 합니다.

타인의 개인정보 도용 또는 부정 사용

서비스를 통한 불법적 행위

시스템에 손상을 입히거나 안정성을 해치는 행위

제6조 (개인정보 보호)
이용자의 개인정보는 관련 법령에 따라 보호되며, [개인정보처리방침]을 따릅니다.

제7조 (서비스 이용 해지)
이용자는 언제든지 앱 내 설정 메뉴를 통해 서비스 이용을 해지할 수 있습니다.

제8조 (책임의 제한)
자연재해, 시스템 장애 등 불가항력적 사유에 대해서는 책임을 지지 않습니다.

이용자의 귀책사유로 인한 피해에 대해서는 서비스가 책임지지 않습니다.

제9조 (준거법 및 관할법원)
본 약관은 대한민국 법률에 따르며, 관련 분쟁은 서울중앙지방법원을 관할 법원으로 합니다.

📅 시행일: 2025년 5월 30일
📧 문의: s24318609@gmail.com
""";

  final service_terms = """

함께하루 서비스 이용약관
본 약관은 함께하루 앱의 구체적인 서비스 이용 방식 및 제한, 이용자의 권리와 책임을 설명합니다.

제1조 (서비스 소개)
‘함께하루’는 디지털 소통에 익숙하지 않은 노인을 위한 일정 공유 및 음성 기반 커뮤니케이션 앱입니다. 보호자와 피보호자가 함께 사용하는 것을 전제로 합니다.

제2조 (제공 서비스)
이용자는 다음과 같은 기능을 이용할 수 있습니다:

일정 등록/조회: 피보호자의 일정을 등록하고 함께 확인

음성 메모 및 안내: 음성으로 내용을 기록하고 음성 합성(TTS)을 통해 전달

채팅 기능: 텍스트 채팅으로 보호자와 실시간 소통

비상 호출: 위급 상황 시 보호자에게 즉시 알림 전송

푸시 알림: 일정 시작, 알림, 메시지 등 중요 사항을 실시간 안내

제3조 (회원가입 및 로그인)
회원가입 시 필요한 최소 정보(이메일, 비밀번호 등)를 입력해야 하며, 구글 또는 카카오 계정 연동도 지원됩니다.

보호자/피보호자 유형에 따라 기능 접근이 제한될 수 있습니다.

제4조 (데이터 보관 및 삭제)
앱에 저장되는 음성, 일정 등의 정보는 개인 기기에 저장되며, 탈퇴 시 자동으로 삭제됩니다.

일부 서버 데이터는 보안상의 이유로 일정 기간 보관될 수 있습니다.

제5조 (이용자 권한 및 책임)
이용자는 앱 내 기록된 정보의 정확성을 유지할 책임이 있습니다.

악의적 행위가 발견될 경우 운영자는 사전 경고 없이 서비스 이용을 제한할 수 있습니다.

제6조 (광고 및 알림 수신)
서비스 운영을 위한 앱 내 알림 및 관련 정보가 제공될 수 있으며, 알림 수신은 설정에서 변경 가능합니다.

📌 주의사항

본 앱은 응급의료 서비스를 대체하지 않으며, 실제 생명 구조 기능은 포함되어 있지 않습니다.

피보호자의 상태 확인은 보호자의 지속적인 관심을 전제로 합니다.

📅 시행일: 2025년 5월 30일
📧 문의: s24318609@gmail.com

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.primary[900],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "이용약관", color: CareConnectColor.white),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semibold_20px(text: "이용 약관"),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CareConnectColor.neutral[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Medium_14px(
                        text: terms,
                        color: CareConnectColor.neutral[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    viewAll(context, terms),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Semibold_20px(text: "서비스 이용 약관"),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CareConnectColor.neutral[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Medium_14px(
                        text: service_terms,
                        color: CareConnectColor.neutral[500],
                      ),
                    ),
                    SizedBox(height: 6),
                    viewAll(context, service_terms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget viewAll(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: CareConnectColor.white,
                contentPadding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: SingleChildScrollView(
                    child: Medium_14px(
                      text: service_terms,
                      color: CareConnectColor.neutral[800],
                    ),
                  ),
                ),
                actions: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "닫기",
                        style: TextStyle(color: CareConnectColor.primary[900]),
                      ),
                    ),
                  ),
                ],
              ),
        );
      },
      child: Text(
        "전문 보기",
        style: TextStyle(
          color: CareConnectColor.neutral[900],
          fontFamily: 'Pretendard',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
