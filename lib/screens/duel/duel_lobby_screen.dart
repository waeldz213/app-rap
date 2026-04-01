import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/duel_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';

class DuelLobbyScreen extends ConsumerStatefulWidget {
  const DuelLobbyScreen({super.key});

  @override
  ConsumerState<DuelLobbyScreen> createState() => _DuelLobbyScreenState();
}

class _DuelLobbyScreenState extends ConsumerState<DuelLobbyScreen> {
  final _codeController = TextEditingController();
  bool _isCreating = false;
  bool _isJoining = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _createDuel() async {
    setState(() => _isCreating = true);
    try {
      final quizService = ref.read(quizServiceProvider);

      // Get questions from first available pack
      final questions = await quizService.getQuestionsForPack(
        'default',
        limit: 5,
      );
      final questionIds = questions.map((q) => q.id).toList();

      final duel = await ref.read(duelNotifierProvider.notifier).createDuel(
            questionIds.isEmpty ? ['q1', 'q2', 'q3', 'q4', 'q5'] : questionIds,
          );

      if (mounted) {
        context.push('/duel/${duel.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  Future<void> _joinDuel() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isJoining = true);
    try {
      final authService = ref.read(authServiceProvider);
      final userId = authService.currentUser?.uid ?? '';

      await ref.read(duelServiceProvider).joinDuel(
            duelId: code,
            opponentUserId: userId,
          );

      if (mounted) {
        context.push('/duel/$code');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Duel introuvable: $e'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Duel 1v1')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('⚔️', style: TextStyle(fontSize: 64))
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 8),
            const Text(
              'Affrontez un adversaire\nen temps réel!',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 40),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Créer un duel',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Créez un duel et partagez le code avec un ami',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    gradient: AppTheme.fireGradient,
                    onPressed: _isCreating ? null : _createDuel,
                    isLoading: _isCreating,
                    text: '⚔️ Créer un Duel',
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rejoindre un duel',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Code du duel',
                      prefixIcon: Icon(Icons.qr_code,
                          color: AppTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    gradient: AppTheme.premiumGradient,
                    onPressed: _isJoining ? null : _joinDuel,
                    isLoading: _isJoining,
                    text: 'Rejoindre',
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            const SizedBox(height: 20),
            // Waiting animation
            if (_isCreating)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('En attente d\'un adversaire...',
                      style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 12),
                  const CircularProgressIndicator(color: AppTheme.primary),
                ],
              ).animate().fadeIn(),
          ],
        ),
      ),
    );
  }
}
