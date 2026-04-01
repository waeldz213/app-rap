import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      emoji: '🎤',
      title: 'Quiz ton savoir rap',
      subtitle:
          'Teste ta connaissance du rap français avec des centaines de questions sur les punchlines, artistes et albums.',
      gradient: AppColors.primaryGradient,
    ),
    _OnboardingPage(
      emoji: '⚔️',
      title: 'Défie tes amis en 1v1',
      subtitle:
          'Lance des duels en temps réel contre tes amis ou des inconnus. Qui est le vrai rappeur ?',
      gradient: LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF97316)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _OnboardingPage(
      emoji: '🃏',
      title: 'Collectionne les légendes',
      subtitle:
          'Ouvre des boosters pour découvrir des cartes rares de tes artistes préférés. Complète ta collection !',
      gradient: AppColors.accentGradient,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Passer'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: page.gradient,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: (page.gradient as LinearGradient)
                                    .colors
                                    .first
                                    .withOpacity(0.4),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              page.emoji,
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        )
                            .animate(key: ValueKey(index))
                            .scale(
                              duration: 500.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('title_$index'))
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.2, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        )
                            .animate(key: ValueKey('sub_$index'))
                            .fadeIn(delay: 350.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.primary
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    text: _currentPage == _pages.length - 1
                        ? 'Commencer'
                        : 'Suivant',
                    onPressed: _nextPage,
                  ),
                  if (_currentPage == _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: const Text("Créer un compte"),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
