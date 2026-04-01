import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/auth_provider.dart';
import '../../config/theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  String _language = 'Français';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          _SectionHeader(title: 'Préférences'),
          _ToggleTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Rappels de défis quotidiens',
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ).animate().fadeIn(delay: 100.ms),
          _ToggleTile(
            icon: Icons.volume_up_outlined,
            title: 'Sons',
            subtitle: 'Effets sonores en jeu',
            value: _soundEnabled,
            onChanged: (v) => setState(() => _soundEnabled = v),
          ).animate().fadeIn(delay: 150.ms),
          _SelectTile(
            icon: Icons.language,
            title: 'Langue',
            value: _language,
            options: const ['Français', 'English'],
            onChanged: (v) => setState(() => _language = v),
          ).animate().fadeIn(delay: 200.ms),
          const _SectionHeader(title: 'Compte'),
          _ActionTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Politique de confidentialité',
            onTap: () async {
              final uri = Uri.parse('https://example.com/privacy');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ).animate().fadeIn(delay: 250.ms),
          _ActionTile(
            icon: Icons.description_outlined,
            title: 'Conditions d\'utilisation',
            onTap: () async {
              final uri = Uri.parse('https://example.com/terms');
              if (await canLaunchUrl(uri)) await launchUrl(uri);
            },
          ).animate().fadeIn(delay: 300.ms),
          _ActionTile(
            icon: Icons.logout,
            title: 'Se déconnecter',
            titleColor: AppTheme.error,
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.surface,
                  title: const Text('Déconnexion',
                      style: TextStyle(color: AppTheme.textPrimary)),
                  content: const Text(
                    'Es-tu sûr de vouloir te déconnecter?',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Déconnecter',
                          style: TextStyle(color: AppTheme.error)),
                    ),
                  ],
                ),
              );
              if (confirmed == true && mounted) {
                await ref.read(authServiceProvider).signOut();
                if (mounted) context.go('/login');
              }
            },
          ).animate().fadeIn(delay: 350.ms),
          const _SectionHeader(title: 'À propos'),
          const _InfoTile(title: 'Version', value: '1.0.0')
              .animate()
              .fadeIn(delay: 400.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.surface,
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(
                  color: AppTheme.textSecondary, fontSize: 13))
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primary,
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _SelectTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.surface,
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: AppTheme.surface,
        underline: const SizedBox.shrink(),
        style: const TextStyle(color: AppTheme.textPrimary),
        items: options
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    this.titleColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.surface,
      leading: Icon(icon,
          color: titleColor ?? AppTheme.textSecondary),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? AppTheme.textPrimary,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(Icons.chevron_right,
          color: AppTheme.textSecondary),
      onTap: onTap,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppTheme.surface,
      title: Text(title,
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15)),
      trailing: Text(value,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
    );
  }
}
