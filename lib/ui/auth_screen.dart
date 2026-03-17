import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'profile_screen.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();

}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _toggleMode() {
    setState(() => isLogin = !isLogin);
  }

  void _submit() async {
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
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Succès !"), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        // Ici, tu pourras ajouter la navigation vers ta page d'accueil
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(isLogin ? "Se connecter" : "S'inscrire"),
                ),

                TextButton(
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