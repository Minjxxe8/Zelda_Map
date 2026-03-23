import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../feed/widgets/app_colors.dart';
import '../app_shell.dart';
import 'widgets/primary_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();

}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _toggleMode() {
    setState(() => isLogin = !isLogin);
  }

  void _submit() async {
    setState(() => _errorMessage = null);

    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider);

      String? error;

      if (isLogin) {
        error = await authNotifier.handleLogin(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      } else {
        error = await authNotifier.handleSignUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _usernameController.text.trim(),
        );
      }

      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur : $error"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      if (error != null && mounted) {
        setState(() => _errorMessage = error);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bienvenue !"), backgroundColor: Colors.green),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AppShell()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.asset(
                    'lib/images/Logo-LesCopines.png',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 8),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.redAccent),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Text(isLogin ? "Connexion" : "Créer un compte",
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 20),

                if (!isLogin) ...[
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                  ),
                  const SizedBox(height: 10),
                ],

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Mot de passe"),
                  obscureText: true,
                ),

                const SizedBox(height: 24),
                PrimaryButton(
                  label: isLogin ? "Se connecter" : "S'inscrire",
                  onTap: _submit,
                  isLoading: isLoading,
                ),

                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: kAccent,
                  ),
                  onPressed: _toggleMode,
                  child: Text(isLogin
                      ? "Pas de compte ? Inscris-toi"
                      : "Déjà un compte ? Connecte-toi"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
