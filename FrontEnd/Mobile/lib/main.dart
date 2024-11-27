import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/splash_screen.dart';
//import 'package:map_flutter/screens/map_screen.dart';
//import 'package:map_flutter/screens/auth/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('fr', ''), // Francais
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}


// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Material App',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
//         home: const MapScreen());
//   }
// }


