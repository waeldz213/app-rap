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
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/onboarding';
      final isSplash = state.matchedLocation == '/';

      if (isSplash) return null;
      if (!isAuthenticated && !isAuthRoute) return '/onboarding';
      if (isAuthenticated && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
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
      ShellRoute(
        builder: (context, state, child) => AppScaffoldWithNav(child: child),
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
                path: ':id',
                builder: (context, state) => PackDetailScreen(
                  packId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/duel/lobby',
            builder: (context, state) => const DuelLobbyScreen(),
          ),
          GoRoute(
            path: '/collection',
            builder: (context, state) => const CollectionScreen(),
            routes: [
              GoRoute(
                path: 'booster',
                builder: (context, state) => const BoosterOpeningScreen(),
              ),
              GoRoute(
                path: ':cardId',
                builder: (context, state) => CardDetailScreen(
                  cardId: state.pathParameters['cardId']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz/:packId',
        builder: (context, state) => QuizScreen(
          packId: state.pathParameters['packId']!,
        ),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return QuizResultScreen(
                score: extra['score'] as int? ?? 0,
                total: extra['total'] as int? ?? 0,
                xpGained: extra['xpGained'] as int? ?? 0,
                coinsGained: extra['coinsGained'] as int? ?? 0,
                packId: state.pathParameters['packId']!,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/duel/:duelId',
        builder: (context, state) => DuelScreen(
          duelId: state.pathParameters['duelId']!,
        ),
        routes: [
          GoRoute(
            path: 'result',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return DuelResultScreen(
                duelId: state.pathParameters['duelId']!,
                myScore: extra['myScore'] as int? ?? 0,
                opponentScore: extra['opponentScore'] as int? ?? 0,
                winnerId: extra['winnerId'] as String? ?? '',
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const ShopScreen(),
        routes: [
          GoRoute(
            path: 'subscription',
            builder: (context, state) => const SubscriptionScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Text(
          'Page introuvable',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    ),
  );
});
