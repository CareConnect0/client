import 'dart:io';

import 'package:client/api/User/user_view_model.dart';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectDialog2.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/api/Auth/auth_repository.dart';
import 'package:client/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

final withdrawalPasswordProvider = StateProvider<String>((ref) => '');

class Profile extends ConsumerWidget {
  Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: CareConnectColor.white,
      appBar: AppBar(
        backgroundColor: CareConnectColor.primary[900],
        surfaceTintColor: Colors.transparent,
        title: Bold_22px(text: "마이페이지", color: CareConnectColor.white),
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
        child: Column(
          children: [
            Myprofile(ref),
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
              false,
            ),
            OptionCard2(
              context,
              "회원탈퇴",
              "회원을 탈퇴하시겠습니까?",
              "회원탈퇴 시, 모든 정보가 사라집니다.",
              () async {
                final password = ref.read(withdrawalPasswordProvider);
                final viewModel = ref.read(userViewModelProvider.notifier);
                await viewModel.withdrawal(password);
                context.go('/');
              },
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget Myprofile(WidgetRef ref) {
    final _imageFile = ref.watch(profileImageFileProvider);

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
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final XFile? picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );

                if (picked != null) {
                  final file = File(picked.path);

                  // ① 서버 업로드
                  await ref
                      .read(userRepositoryProvider)
                      .uploadProfileImage(file);

                  // ② Riverpod 상태 갱신
                  ref.read(profileImageFileProvider.notifier).state = file;
                }
              },
              child: Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        _imageFile != null
                            ? FileImage(_imageFile)
                            : AssetImage("assets/images/example.png")
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Bold_24px(text: "${ref.watch(userNameProvider)}님"),
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
    bool textfield,
  ) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => CareConnectDialog2(
                titleText: titleText,
                contentText: contentText,
                done: () async {
                  context.pop();
                  await route();
                },
                hasTextField: textfield,
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
