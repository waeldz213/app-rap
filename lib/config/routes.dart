import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/packs/packs_screen.dart';
import '../screens/packs/pack_detail_screen.dart';
import '../screens/quiz/quiz_screen.dart';
import '../screens/quiz/quiz_result_screen.dart';
import '../screens/duel/duel_lobby_screen.dart';
import '../screens/duel/duel_screen.dart';
import '../screens/duel/duel_result_screen.dart';
import '../screens/collection/collection_screen.dart';
import '../screens/collection/card_detail_screen.dart';
import '../screens/collection/booster_opening_screen.dart';
import '../screens/shop/shop_screen.dart';
import '../screens/shop/subscription_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/app_bottom_nav.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isSplash = state.matchedLocation == '/splash';
      final isOnboarding = state.matchedLocation == '/onboarding';
      final isAuth = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (isSplash) return null;
      if (!isLoggedIn && !isAuth && !isOnboarding) return '/login';
      if (isLoggedIn && isAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/quiz/:packId',
        builder: (context, state) => QuizScreen(
          packId: state.pathParameters['packId']!,
        ),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) => QuizResultScreen(
              packId: state.pathParameters['packId']!,
              extra: state.extra as Map<String, dynamic>?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/duel/lobby',
        builder: (context, state) => const DuelLobbyScreen(),
      ),
      GoRoute(
        path: '/duel/:duelId',
        builder: (context, state) => DuelScreen(
          duelId: state.pathParameters['duelId']!,
        ),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) => DuelResultScreen(
              duelId: state.pathParameters['duelId']!,
              extra: state.extra as Map<String, dynamic>?,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/collection/booster',
        builder: (context, state) => BoosterOpeningScreen(
          extra: state.extra as Map<String, dynamic>?,
        ),
      ),
      GoRoute(
        path: '/collection/:cardId',
        builder: (context, state) => CardDetailScreen(
          cardId: state.pathParameters['cardId']!,
        ),
      ),
      GoRoute(
        path: '/shop/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/packs',
            builder: (context, state) => const PacksScreen(),
            routes: [
              GoRoute(
                path: ':packId',
                builder: (context, state) => PackDetailScreen(
                  packId: state.pathParameters['packId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/collection',
            builder: (context, state) => const CollectionScreen(),
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) => const ShopScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
