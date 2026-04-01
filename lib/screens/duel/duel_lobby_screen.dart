import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/pack_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/duel_provider.dart';
import '../../services/pack_service.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/glass_card.dart';

class DuelLobbyScreen extends ConsumerStatefulWidget {
  const DuelLobbyScreen({super.key});

  @override
  ConsumerState<DuelLobbyScreen> createState() => _DuelLobbyScreenState();
}

class _DuelLobbyScreenState extends ConsumerState<DuelLobbyScreen> {
  final _codeController = TextEditingController();
  String? _selectedPackId;
  bool _isCreating = false;
  bool _isJoining = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _createDuel() async {
    if (_selectedPackId == null) {
      setState(() => _error = 'Sélectionne un pack');
      return;
    }
    setState(() {
      _isCreating = true;
      _error = null;
    });

    try {
      final user = ref.read(currentUserProvider);
      final userModel = ref.read(userModelProvider).valueOrNull;
      if (user == null || userModel == null) throw Exception('Non connecté');

      final packService = PackService();
      final questions =
          await packService.getQuestionsForPack(_selectedPackId!);
      final questionIds = questions.map((q) => q.id).toList();

      final pack = await packService.getPackById(_selectedPackId!);

      final duel = await ref.read(duelServiceProvider).createDuel(
            initiatorUserId: user.uid,
            initiatorDisplayName: userModel.displayName,
            packId: _selectedPackId!,
            packTitle: pack?.title ?? '',
            questionIds: questionIds,
          );

      if (mounted) {
        _showWaitingDialog(duel.inviteCode, duel.id);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  void _showWaitingDialog(String code, String duelId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Duel créé ! ⚔️',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Partage ce code à ton adversaire :',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copié !')),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy, color: AppColors.textMuted, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            const Text(
              'En attente de l\'adversaire...',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/duel/$duelId');
            },
            child: const Text('Aller au duel'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinDuel() async {
    final code = _codeController.text.trim().toUpperCase();
    if (code.length != 6) {
      setState(() => _error = 'Code à 6 caractères requis');
      return;
    }

    setState(() {
      _isJoining = true;
      _error = null;
    });

    try {
      final user = ref.read(currentUserProvider);
      final userModel = ref.read(userModelProvider).valueOrNull;
      if (user == null || userModel == null) throw Exception('Non connecté');

      final duel = await ref.read(duelServiceProvider).joinDuelByCode(
            inviteCode: code,
            opponentUserId: user.uid,
            opponentDisplayName: userModel.displayName,
          );

      if (duel == null) {
        setState(() => _error = 'Code invalide ou duel introuvable.');
        return;
      }

      if (mounted) context.go('/duel/${duel.id}');
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final packsAsync = ref.watch(packsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('⚔️ Duel 1v1')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Créer un duel',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choisir un pack',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  packsAsync.when(
                    data: (packs) => DropdownButtonFormField<String>(
                      value: _selectedPackId,
                      dropdownColor: AppColors.surfaceVariant,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.surfaceVariant),
                        ),
                      ),
                      items: packs
                          .map((p) => DropdownMenuItem(
                                value: p.id,
                                child: Text(
                                    '${p.iconEmoji} ${p.title}'),
                              ))
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedPackId = v),
                    ),
                    loading: () =>
                        const CircularProgressIndicator(),
                    error: (_, __) =>
                        const Text('Erreur chargement packs'),
                  ),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: 'Créer le duel',
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                    ),
                    onPressed: _createDuel,
                    isLoading: _isCreating,
                    icon: Icons.sports_kabaddi,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Rejoindre un duel',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                children: [
                  TextField(
                    controller: _codeController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'CODE',
                      hintStyle: TextStyle(
                        color: AppColors.textMuted,
                        letterSpacing: 4,
                      ),
                      prefixIcon: Icon(Icons.tag,
                          color: AppColors.textMuted),
                    ),
                    maxLength: 6,
                  ),
                  const SizedBox(height: 8),
                  GradientButton(
                    text: 'Rejoindre',
                    onPressed: _joinDuel,
                    isLoading: _isJoining,
                    icon: Icons.login,
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
