import 'dart:async';
import 'dart:convert';
import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
import 'package:client/Auth/auth_repository.dart';
import 'package:client/Auth/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _startApp();
    // Progress animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  Future<void> _startApp() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    print('accessToken: $accessToken');
    print('refreshToken: $refreshToken');

    if (accessToken != null && refreshToken != null) {
      try {
        // 토큰이 만료되지 않았다면 바로 홈으로 이동
        if (!isTokenExpired(accessToken)) {
          print('토큰이 만료되지 않았다면 바로 홈으로 이동');
          context.pushReplacement('/home');
        } else {
          // 토큰 만료 시 재발급 시도
          print('토큰 만료 시 재발급 시도');
          await AuthRepository().reissueToken();
          context.pushReplacement('/home');
        }
      } catch (e) {
        // 토큰 재발급 실패 시 로그인 화면으로 이동
        print('토큰 재발급 실패 시 로그인 화면으로 이동');
        await AuthStorage.clear();
        context.pushReplacement('/sign');
      }
    } else {
      print('토큰이 없으면 로그인 화면으로 이동');
      context.pushReplacement('/sign'); // 토큰이 없으면 로그인 화면으로 이동
    }
  }

  bool isTokenExpired(String token) {
    try {
      // "Bearer " 접두사 제거
      if (token.startsWith('Bearer ')) {
        token = token.substring(7);
      }

      final parts = token.split('.');
      if (parts.length != 3) {
        return true; // 올바른 JWT 형식이 아님
      }

      // 패딩 처리
      String normalizedPayload = parts[1];
      while (normalizedPayload.length % 4 != 0) {
        normalizedPayload += '=';
      }

      final decodedToken =
          jsonDecode(utf8.decode(base64Url.decode(normalizedPayload)));
      final exp = decodedToken['exp']; // 만료 시간 (Unix timestamp)
      final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

      print('Token exp: $exp, Current time: $currentTime');
      return currentTime > exp; // 현재 시간이 만료 시간보다 크면 만료된 토큰
    } catch (e) {
      print('Token validation error: $e');
      return true; // 토큰 파싱에 실패하면 만료된 것으로 간주
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              CareConnectColor.black.withOpacity(0.65),
              BlendMode.srcOver,
            ),
            image: const AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/logo.svg"),
              const SizedBox(height: 15),
              Semibold_28px(
                text: "함께하루",
                color: CareConnectColor.primary[900],
              ),
              const SizedBox(height: 83),
              Bold_26px(
                text: "당신과 함께 만드는",
                color: CareConnectColor.white,
              ),
              Bold_26px(
                text: "행복한 노후생활",
                color: CareConnectColor.white,
              ),
              const SizedBox(height: 36),
              AnimatedBuilder(
                animation: _progress,
                builder: (context, child) {
                  return Container(
                    width: 108,
                    height: 7,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: CareConnectColor.primary[900]!.withOpacity(0.7),
                    ),
                    child: LinearProgressIndicator(
                      value: _progress.value,
                      color: CareConnectColor.white,
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
