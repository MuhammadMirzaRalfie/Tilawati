import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/evaluation_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/jilid_selection_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/evaluation_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/glossary_screen.dart';
import 'screens/glossary_detail_screen.dart';
import 'screens/history_screen.dart';
import 'screens/free_inference_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Status bar diatur per-theme via appBarTheme.systemOverlayStyle.
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;
  await NotificationService.init();
  runApp(TilawatiApp(isDark: isDark));
}

class TilawatiApp extends StatelessWidget {
  final bool isDark;
  const TilawatiApp({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => EvaluationProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider(isDark)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
        title: 'Tilawati',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/jilid-selection': (context) => const JilidSelectionScreen(),
          '/lesson': (context) => const LessonScreen(),
          '/evaluation': (context) => const EvaluationScreen(),
          '/progress': (context) => const ProgressScreen(),
          '/glossary': (context) => const GlossaryScreen(),
          '/glossary-detail': (context) => const GlossaryDetailScreen(),
          '/riwayat': (context) => const HistoryScreen(),
          '/free-inference': (context) => const FreeInferenceScreen(),
        },
        ),
      ),
    );
  }
}
