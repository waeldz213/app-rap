import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          _SectionHeader('Général'),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Thème',
            subtitle: 'Mode sombre (par défaut)',
            trailing: const Icon(Icons.lock_outline,
                color: AppColors.textMuted, size: 18),
          ),
          _SectionHeader('Contenu'),
          _SettingsTile(
            icon: Icons.notifications_active_outlined,
            title: 'Défi du jour',
            subtitle: 'Rappel quotidien à 9h',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Icons.sports_kabaddi_outlined,
            title: 'Notifications de duel',
            subtitle: 'Quand un adversaire te défie',
            trailing: Switch(
              value: true,
              onChanged: (_) {},
              activeColor: AppColors.primary,
            ),
          ),
          _SectionHeader('Compte'),
          _SettingsTile(
            icon: Icons.workspace_premium_outlined,
            title: 'Gérer l\'abonnement',
            onTap: () => context.go('/shop/subscription'),
          ),
          _SettingsTile(
            icon: Icons.restore_outlined,
            title: 'Restaurer les achats',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restauration...')),
              );
            },
          ),
          _SectionHeader('À propos'),
          _SettingsTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: '1.0.0',
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            onTap: () {},
          ),
          _SettingsTile(
            icon: Icons.description_outlined,
            title: 'Conditions d\'utilisation',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('Déconnexion',
                        style:
                            TextStyle(color: AppColors.textPrimary)),
                    content: const Text(
                      'Veux-tu vraiment te déconnecter ?',
                      style:
                          TextStyle(color: AppColors.textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx, false),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx, true),
                        child: const Text(
                          'Déconnecter',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) context.go('/onboarding');
                }
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text(
                'Se déconnecter',
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 12),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right,
                  color: AppColors.textMuted)
              : null),
      onTap: onTap,
    );
  }
}
