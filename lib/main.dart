import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zelda_map/services/supabase_service.dart';
import 'package:zelda_map/ui/authentification/auth_screen.dart';
import 'package:zelda_map/ui/feed/widgets/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zelda_map/ui/widgets/app_page_app_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Les copines',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
          background: kBackground,
          surface: kBackground,
          onBackground: kTextPrimary,
          onSurface: kTextPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBackground,
          foregroundColor: kTextPrimary,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: kTextPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: kTextPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: kTextPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(
            color: kTextPrimary,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: kTextPrimary,
            fontSize: 14,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: kSurface,
          labelStyle: TextStyle(color: kTextSecondary),
        ),
      ),
      home: const AppBootstrapScreen(),
    );
  }
}

class AppBootstrapScreen extends StatefulWidget {
  const AppBootstrapScreen({super.key});

  @override
  State<AppBootstrapScreen> createState() => _AppBootstrapScreenState();
}

class _AppBootstrapScreenState extends State<AppBootstrapScreen> {
  late Future<void> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _bootstrap();
  }

  Future<void> _bootstrap() async {
    await dotenv.load();
    await SupabaseService.init().timeout(const Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _bootstrapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            appBar: AppPageAppBar(title: 'Chargement'),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: const AppPageAppBar(title: 'Erreur'),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Le demarrage a echoue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _bootstrapFuture = _bootstrap();
                        });
                      },
                      child: const Text('Reessayer'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const AuthScreen();
      },
    );
  }
}
