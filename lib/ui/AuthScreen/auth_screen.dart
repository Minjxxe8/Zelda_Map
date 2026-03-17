import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer le texte
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  void _toggleMode() {
    setState(() => isLogin = !isLogin);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      print("Tentative de ${isLogin ? 'Connexion' : 'Inscription'}");
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