import 'package:client/designs/CareConnectColor.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/sign_in.dart';
import 'package:client/screens/signUp/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/signIn',
        builder: (context, state) => const SignIn(),
      ),
      GoRoute(
        path: '/signUp',
        builder: (context, state) => const SignUp(),
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: CareConnectColor.neutral[50]!),
        appBarTheme: AppBarTheme(
            // systemOverlayStyle: SystemUiOverlayStyle(
            //   statusBarColor: Colors.transparent,
            //   statusBarIconBrightness: Brightness.light,
            // ),
            ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
