import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/evaluation_provider.dart';
import 'providers/progress_provider.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TilawatiApp());
}

class TilawatiApp extends StatelessWidget {
  const TilawatiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => EvaluationProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
      ],
      child: MaterialApp(
        title: 'Tilawati',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
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
    );
  }
}
