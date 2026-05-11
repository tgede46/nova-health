import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}
class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _showAuthForm(BuildContext context, bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 24,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isLogin ? 'Se connecter' : 'Créer un compte',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bleuMarine,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    if (!_isLogin) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Nom complet',
                          filled: true,
                          fillColor: const Color(0xFFF0F0EE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: const Color(0xFFF0F0EE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Mot de passe',
                        filled: true,
                        fillColor: const Color(0xFFF0F0EE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        bool isValid = _isLogin 
                            ? _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty
                            : _nameController.text.isNotEmpty && _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

                        if (isValid) {
                          Navigator.pop(context); // Close bottom sheet
                          Navigator.pop(this.context, true); // Return to chat
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Veuillez remplir tous les champs')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.vertTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _isLogin ? 'Connexion' : 'S\'inscrire',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? "Pas encore de compte ? S'inscrire" : "Déjà un compte ? Se connecter",
                        style: const TextStyle(color: AppColors.bleuMarine, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top section with Logo/Text
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 280, // Adjust width as needed for the layout
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Bottom section with buttons
          Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
            decoration: const BoxDecoration(
              color: AppColors.bleuMarine,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Continue with Apple
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.apple, color: AppColors.bleuMarine, size: 24),
                    label: const Text(
                      'Continuer avec Apple',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.bleuMarine),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Continue with Google
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.g_mobiledata, color: AppColors.bleuMarine, size: 28),
                    label: const Text(
                      'Continuer avec Google',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.bleuMarine),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Sign up
                  ElevatedButton(
                    onPressed: () => _showAuthForm(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.vertTeal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'S\'inscrire',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Log in
                  OutlinedButton(
                    onPressed: () => _showAuthForm(context, true),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.bleuCiel, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Se connecter',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
