import 'package:client/designs/CareConnectColor.dart';
import 'package:client/model/availableUser.dart';
import 'package:client/model/emergencyItem.dart';
import 'package:client/model/messengerInfo.dart';
import 'package:client/model/singUp.dart';
import 'package:client/screens/ai_chat/ai_chat.dart';
import 'package:client/screens/emergency/emergency_family.dart';
import 'package:client/screens/emergency_player/view.dart';
import 'package:client/screens/notification/emergency_notification.dart';
import 'package:client/screens/notification/my_notification.dart';
import 'package:client/screens/profile/change_password.dart';
import 'package:client/screens/profile/profile.dart';
import 'package:client/screens/profile/profile_terms.dart';
import 'package:client/screens/schedule/calendar.dart';
import 'package:client/screens/messenger/confirmMessage.dart';
import 'package:client/screens/schedule/confirmSchedule/view.dart';
import 'package:client/screens/ai_chat/confirm_ai_chat.dart';
import 'package:client/screens/messenger/enrollMessage.dart';
import 'package:client/screens/schedule/enrollSchedule.dart';
import 'package:client/screens/ai_chat/enroll_ai_chat.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/messenger/contact.dart';
import 'package:client/screens/messenger/messenger.dart';
import 'package:client/screens/signUp/connect_family/view.dart';
import 'package:client/screens/splashSign.dart';
import 'package:client/screens/signUp/check_verification/view.dart';
import 'package:client/screens/signUp/id_verification/view.dart';
import 'package:client/screens/signUp/congratulation.dart';
import 'package:client/screens/signUp/enroll_info/view.dart';
import 'package:client/screens/signIn/view.dart';
import 'package:client/screens/signUp/sign_up.dart';
import 'package:client/screens/splash.dart';
import 'package:client/screens/schedule/timeTable/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'api/Chatting/chatting_view_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => Splash()),
      GoRoute(path: '/sign', builder: (context, state) => const SplashSign()),
      GoRoute(path: '/signIn', builder: (context, state) => SignIn()),
      GoRoute(path: '/signUp', builder: (context, state) => const SignUp()),
      GoRoute(
        path: '/signUp/enrollInfo',
        builder: (context, state) => EnrollInfo(),
      ),
      GoRoute(
        path: '/signUp/idVerification',
        builder: (context, state) {
          final signupData = state.extra as SignupData;
          return IdVerification(signupData: signupData);
        },
      ),
      GoRoute(
        path: '/signUp/checkVerification',
        builder: (context, state) {
          final signupData = state.extra as SignupData;
          return CheckVerification(signupData: signupData);
        },
      ),
      GoRoute(
        path: '/signUp/checkVerification/connect',
        builder: (context, state) {
          return ConnectFamily();
        },
      ),
      GoRoute(
        path: '/signUp/congratulation',
        builder: (context, state) => Congratulation(),
      ),
      GoRoute(path: '/home', builder: (context, state) => Home()),
      GoRoute(path: '/calendar', builder: (context, state) => Calendar()),
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
      GoRoute(path: '/contact', builder: (context, state) => Contact()),
      GoRoute(
        path: '/contact/messenger',
        name: 'Messenger',
        builder: (context, state) {
          final user = state.extra! as AvailableUser;
          return Messenger(user);
        },
      ),
      GoRoute(
        path: '/contact/messenger/enroll',
        builder: (context, state) => EnrollMessage(),
      ),
      GoRoute(
        path: '/contact/messenger/confirm',
        builder: (context, state) => ConfirmMessage(),
      ),
      GoRoute(path: '/ai', builder: (context, state) => AIChat()),
      GoRoute(path: '/ai/enroll', builder: (context, state) => EnrollAiChat()),
      GoRoute(
        path: '/ai/confirm',
        builder: (context, state) => ConfirmAiChat(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => Profile()),
      GoRoute(
        path: '/profile/password',
        builder: (context, state) => ChangePassword(),
      ),
      GoRoute(
        path: '/profile/terms',
        builder: (context, state) => ProfileTerms(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => MyNotification(),
      ),
      GoRoute(
        path: '/notification/emergency',
        name: 'Emergency',
        builder: (context, state) {
          final args = state.extra as EmergencyDetailArgs;
          return EmergencyNotification(args.emergency, args.dependentName);
        },
      ),
      GoRoute(
        path: '/emergency/family',
        builder: (context, state) => EmergencyFamily(),
      ),
      GoRoute(
        path: '/emergency/player',
        builder: (context, state) => EmergencyPlayer(),
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  // ✅ 중복 초기화 방지
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // 알림 권한 요청 (iOS 필수)
  await messaging.requestPermission(alert: true, badge: true, sound: true);
  // 포그라운드 메시지 수신
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Foreground 알림 수신: ${message.notification?.title}');
  });
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
      supportedLocales: const [Locale('ko', 'KR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
