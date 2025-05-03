import 'package:client/designs/CareConnectColor.dart';
import 'package:client/screens/calendar.dart';
import 'package:client/screens/confirmSchedule.dart';
import 'package:client/screens/enrollSchedule.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/messenger.dart';
import 'package:client/screens/splashSign.dart';
import 'package:client/screens/signUp/check_verification.dart';
import 'package:client/screens/signUp/id_verification.dart';
import 'package:client/screens/signUp/congratulation.dart';
import 'package:client/screens/signUp/enroll_info.dart';
import 'package:client/screens/signIn/sign_in.dart';
import 'package:client/screens/signUp/sign_up.dart';
import 'package:client/screens/splash.dart';
import 'package:client/screens/timeTable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/messenger',
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
      GoRoute(
        path: '/calendar',
        builder: (context, state) => Calendar(),
      ),
      GoRoute(
        path: '/calendar/timetable',
        name: 'TimeTable',
        builder: (context, state) {
          final selected = state.extra! as DateTime;
          return TimeTable(selected);
        },
      ),
      GoRoute(
        path: '/calendar/enroll',
        builder: (context, state) => EnrollSchedule(),
      ),
      GoRoute(
        path: '/calendar/enroll/confirm',
        builder: (context, state) => ConfirmSchedule(),
      ),
      GoRoute(
        path: '/messenger',
        builder: (context, state) => Messenger(),
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
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
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
