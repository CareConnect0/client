import 'dart:async';

import 'package:client/designs/CareConnectColor.dart';
import 'package:client/designs/CareConnectTypo.dart';
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

    // 3초 후 /sign 이동
    Timer(const Duration(seconds: 3), () {
      context.go('/sign');
    });

    // Progress animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
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

              // Progress 바
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
