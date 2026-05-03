import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../main.dart';
import '../screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  final bool isLoggedIn;
  
  const AppDrawer({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.bleuMarine,
            ),
            accountName: Text(
              isLoggedIn ? 'Utilisateur NOVA' : 'Invité',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              isLoggedIn ? 'utilisateur@novahealth.com' : 'Connectez-vous pour plus de fonctionnalités',
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isLoggedIn ? Icons.person : Icons.person_outline,
                color: AppColors.bleuMarine,
                size: 32,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.bleuCiel),
            title: const Text('Paramètres Profil'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (_, ThemeMode currentMode, __) {
              final isDark = currentMode == ThemeMode.dark;
              return SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.bleuCiel,
                ),
                title: const Text('Mode Sombre'),
                value: isDark,
                onChanged: (bool value) {
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
          const Spacer(),
          if (isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Se déconnecter', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion simulée')),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
