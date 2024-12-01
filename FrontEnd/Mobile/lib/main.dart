import 'package:flutter/material.dart';
import 'package:map_flutter/screens/auth/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:map_flutter/screens/map_screen.dart';
import 'generated/l10n.dart';
import 'package:map_flutter/screens/sidemenu/settings/settings_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/change_password_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/change_language_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/privacy_policy_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/contact_us_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/delete_account_screen.dart';
import 'package:map_flutter/screens/auth/conducteur_register_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
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
        '/settings': (context) => const SettingsScreen(),
        '/change-password': (context) => const ChangePasswordScreen(),
        '/change-language': (context) => const ChangeLanguageScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
        '/delete-account': (context) => const DeleteAccountScreen(),
        '/conducteur-register': (context) => const ConducteurRegisterScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}