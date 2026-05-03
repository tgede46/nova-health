import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/top_notification.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Utilisateur NOVA');
  final TextEditingController _nicknameController = TextEditingController(text: 'NOVA');
  final TextEditingController _prefController = TextEditingController(
    text: "Lorsque j'apprends de nouveaux concepts, je trouve les analogies particulièrement utiles.",
  );

  bool _isUpdating = false;
  bool _isSavingPrefs = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _prefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF121212) : const Color(0xFFF9F9F8);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
        title: Text(
          'Profil',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.bleuMarine,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nom complet', isDark),
            _buildTextField(_nameController, isDark),
            const SizedBox(height: 16),

            // Surnom
            _buildLabel('Surnom', isDark),
            _buildTextField(_nicknameController, isDark),
            const SizedBox(height: 20),

            // Bouton Mettre à jour
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isUpdating ? null : () async {
                  setState(() => _isUpdating = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) {
                    setState(() => _isUpdating = false);
                    TopNotification.show(context, 'Profil mis à jour');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUpdating ? Colors.grey[400] : (isDark ? Colors.white : AppColors.bleuMarine),
                  foregroundColor: isDark ? AppColors.bleuMarine : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isUpdating 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Mettre à jour le profil',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Préférences personnelles
            _buildLabel('Préférences personnelles', isDark),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _prefController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Décrivez vos préférences...',
                    ),
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vos préférences s\'appliqueront à toutes les conversations, conformément aux directives de NOVA.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Bouton Enregistrer Préférences
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSavingPrefs ? null : () async {
                  setState(() => _isSavingPrefs = true);
                  await Future.delayed(const Duration(seconds: 2));
                  if (mounted) {
                    setState(() => _isSavingPrefs = false);
                    TopNotification.show(context, 'Préférences enregistrées');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _isSavingPrefs
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Enregistrer les préférences',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ),
            ),
            const SizedBox(height: 24),

            // Supprimer le compte
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, color: Color(0xFF8B0000)),
                label: const Text(
                  'Supprimer le compte',
                  style: TextStyle(color: Color(0xFF8B0000), fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
