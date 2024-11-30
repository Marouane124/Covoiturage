import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/conducteur_register_screen.dart';
import 'package:map_flutter/screens/auth/splash_screen.dart';
//import 'package:map_flutter/screens/map_screen.dart';
//import 'package:map_flutter/screens/auth/welcome_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:map_flutter/screens/map_screen.dart';
import 'generated/l10n.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const SplashScreen(),
      routes: {
        '/map': (context) => const MapScreen(),
        '/conducteur-register': (context) => const ConducteurRegisterScreen(),
        // ... other routes ...
      },
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


