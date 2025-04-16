import 'package:client/designs/CareConnectColor.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/splashSign.dart';
import 'package:client/screens/signUp/check_verification.dart';
import 'package:client/screens/signUp/id_verification.dart';
import 'package:client/screens/signUp/congratulation.dart';
import 'package:client/screens/signUp/enroll_info.dart';
import 'package:client/screens/signIn/sign_in.dart';
import 'package:client/screens/signUp/sign_up.dart';
import 'package:client/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Splash(),
      ),
      GoRoute(
        path: '/sign',
        builder: (context, state) => const SplashSign(),
      ),
      GoRoute(
        path: '/signIn',
        builder: (context, state) => SignIn(),
      ),
      GoRoute(
        path: '/signUp',
        builder: (context, state) => const SignUp(),
      ),
      GoRoute(
        path: '/signUp/enrollInfo',
        builder: (context, state) => EnrollInfo(),
      ),
      GoRoute(
        path: '/signUp/idVerification',
        builder: (context, state) => IdVerification(),
      ),
      GoRoute(
        path: '/signUp/checkVerification',
        builder: (context, state) => CheckVerification(),
      ),
      GoRoute(
        path: '/signUp/congratulation',
        builder: (context, state) => Congratulation(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => Home(),
      ),
    ],
  );
});

void main() {
  runApp(const ProviderScope(child: CareConnect()));
}

class CareConnect extends ConsumerWidget {
  const CareConnect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'CareConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: CareConnectColor.white),
        appBarTheme: AppBarTheme(
            // systemOverlayStyle: SystemUiOverlayStyle(
            //   statusBarColor: Colors.transparent,
            //   statusBarIconBrightness: Brightness.light,
            // ),
            ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: CareConnectColor.neutral[700],
          selectionColor: CareConnectColor.neutral[700],
          selectionHandleColor: CareConnectColor.neutral[700],
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
