import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/pack_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/pack_card.dart';

class PacksScreen extends ConsumerWidget {
  const PacksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packsAsync = ref.watch(packsProvider);
    final userAsync = ref.watch(userModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Packs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined,
                color: AppColors.accent),
            onPressed: () => context.go('/shop/subscription'),
            tooltip: 'Passer Premium',
          ),
        ],
      ),
      body: packsAsync.when(
        data: (packs) => userAsync.when(
          data: (user) => GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: packs.length,
            itemBuilder: (context, index) {
              final pack = packs[index];
              final isPremium = user?.isPremium ?? false;
              final locked = !pack.isFree && !isPremium;
              return PackCard(
                pack: pack,
                locked: locked,
                onTap: () => context.go('/packs/${pack.id}'),
              );
            },
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (_, __) =>
              const Center(child: Text('Erreur')),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            'Erreur: $e',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
