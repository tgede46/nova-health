import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../main.dart';
import '../screens/profile_screen.dart';
import '../screens/notifications_screen.dart';

class SettingsOverlay extends StatelessWidget {
  final bool isLoggedIn;
  final VoidCallback onLogout;
  final VoidCallback onLogin;
  
  const SettingsOverlay({
    super.key, 
    required this.isLoggedIn,
    required this.onLogout,
    required this.onLogin,
  });

  static void show(BuildContext context, bool isLoggedIn, VoidCallback onLogout, VoidCallback onLogin) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SettingsOverlay(
        isLoggedIn: isLoggedIn,
        onLogout: onLogout,
        onLogin: onLogin,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final iconBgColor = isDark ? Colors.white10 : const Color(0xFFF4F4F2);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: iconBgColor,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
                Text(
                  'Paramètres',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.bleuMarine,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                  style: IconButton.styleFrom(
                    backgroundColor: iconBgColor,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Top section
                _buildMenuItem(context, Icons.person_outline, 'Profil', () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                }),
                
                const Divider(height: 24, thickness: 1),

                _buildMenuItem(context, Icons.tune, 'Capacités', () {}),
                _buildMenuItem(context, Icons.hub_outlined, 'Connecteurs', () {}),
                _buildMenuItem(context, Icons.lock_outline, 'Autorisations', () {}),

                const Divider(height: 24, thickness: 1),

                // Appearance Preference
                _buildPreferenceItem(
                  context,
                  Icons.dark_mode_outlined,
                  'Apparence',
                  PopupMenuButton<ThemeMode>(
                    initialValue: themeNotifier.value,
                    onSelected: (ThemeMode mode) {
                      themeNotifier.value = mode;
                    },
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<ThemeMode>>[
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.light,
                        child: Row(
                          children: [
                            Icon(Icons.light_mode, color: themeNotifier.value == ThemeMode.light ? AppColors.vertTeal : Colors.grey),
                            const SizedBox(width: 12),
                            const Text('Clair'),
                          ],
                        ),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.dark,
                        child: Row(
                          children: [
                            Icon(Icons.dark_mode, color: themeNotifier.value == ThemeMode.dark ? AppColors.vertTeal : Colors.grey),
                            const SizedBox(width: 12),
                            const Text('Sombre'),
                          ],
                        ),
                      ),
                      PopupMenuItem<ThemeMode>(
                        value: ThemeMode.system,
                        child: Row(
                          children: [
                            Icon(Icons.brightness_auto, color: themeNotifier.value == ThemeMode.system ? AppColors.vertTeal : Colors.grey),
                            const SizedBox(width: 12),
                            const Text('Système'),
                          ],
                        ),
                      ),
                    ],
                    child: ValueListenableBuilder<ThemeMode>(
                      valueListenable: themeNotifier,
                      builder: (context, mode, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              mode == ThemeMode.system ? 'Système' : (mode == ThemeMode.dark ? 'Sombre' : 'Clair'),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.unfold_more, size: 20, color: Colors.grey),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Language Preference
                _buildPreferenceItem(
                  context,
                  Icons.language,
                  'Langue vocale',
                  PopupMenuButton<String>(
                    initialValue: localeNotifier.value,
                    onSelected: (String lang) {
                      localeNotifier.value = lang;
                    },
                    offset: const Offset(0, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'EN',
                        child: Row(
                          children: [
                            Text('EN', style: TextStyle(color: localeNotifier.value == 'EN' ? AppColors.vertTeal : Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            const Text('English'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'FR',
                        child: Row(
                          children: [
                            Text('FR', style: TextStyle(color: localeNotifier.value == 'FR' ? AppColors.vertTeal : Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 12),
                            const Text('Français'),
                          ],
                        ),
                      ),
                    ],
                    child: ValueListenableBuilder<String>(
                      valueListenable: localeNotifier,
                      builder: (context, lang, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(lang, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(width: 4),
                            const Icon(Icons.unfold_more, size: 20, color: Colors.grey),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                _buildMenuItem(context, Icons.notifications_none, 'Notifications', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
                }),
                _buildMenuItem(context, Icons.security_outlined, 'Vie privée', () {}),

                const SizedBox(height: 16),

                // Login/Logout
                ListTile(
                  dense: true,
                  leading: Icon(
                    isLoggedIn ? Icons.logout : Icons.login, 
                    color: Colors.grey,
                  ),
                  title: Text(
                    isLoggedIn ? 'Se déconnecter' : 'Se connecter', 
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close settings
                    if (isLoggedIn) {
                      onLogout();
                    } else {
                      onLogin();
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 24, color: AppColors.bleuMarine),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildPreferenceItem(BuildContext context, IconData icon, String title, Widget trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.bleuMarine),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          trailing,
        ],
      ),
    );
  }
}
