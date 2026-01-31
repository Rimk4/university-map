import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bangkok_university/app.dart';
import 'package:provider/provider.dart';

// Временные заглушки для провайдеров
class MapProvider extends ChangeNotifier {}
class UserProvider extends ChangeNotifier {}
class ActivityProvider extends ChangeNotifier {}
class QRProvider extends ChangeNotifier {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Фиксируем ориентацию
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const BangkokUniversityApp());
}

class BangkokUniversityApp extends StatelessWidget {
  const BangkokUniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MapProvider>(create: (_) => MapProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<ActivityProvider>(create: (_) => ActivityProvider()),
        ChangeNotifierProvider<QRProvider>(create: (_) => QRProvider()),
      ],
      child: MaterialApp(
        title: 'Bangkok University Campus',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A), // Синий университета
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const App(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
