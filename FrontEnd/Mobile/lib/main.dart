import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:map_flutter/screens/auth/login_screen.dart';
import 'package:map_flutter/screens/auth/register_screen.dart';
import 'package:map_flutter/screens/auth/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:map_flutter/screens/auth/welcome_screen.dart';
import 'package:map_flutter/screens/chat_page.dart';
import 'package:map_flutter/screens/navigationmenu/map_screen.dart';
import 'package:map_flutter/screens/navigationmenu/profil_screen.dart';
import 'generated/l10n.dart';
import 'package:map_flutter/screens/sidemenu/settings/settings_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/change_password_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/change_language_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/privacy_policy_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/contact_us_screen.dart';
import 'package:map_flutter/screens/sidemenu/settings/delete_account_screen.dart';
import 'package:map_flutter/screens/auth/conducteur_register_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/navigationmenu/wallet/wallet_screen.dart';
import 'package:map_flutter/services/auth_service.dart';
import 'package:map_flutter/widgets/auth_wrapper.dart';
import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          locale: localeProvider.locale,
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
          home: const AuthWrapper(child: SplashScreen()),
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/chat': (context) => ChatPage(),
            '/map': (context) => const AuthWrapper(
                  requireAuth: true,
                  child: MapScreen(),
                ),
            '/profile': (context) => const AuthWrapper(
                  requireAuth: true,
                  child: ProfileScreen(),
                ),
            '/settings': (context) => const SettingsScreen(),
            '/change-password': (context) => const ChangePasswordScreen(),
            '/change-language': (context) => const ChangeLanguageScreen(),
            '/privacy-policy': (context) => const PrivacyPolicyScreen(),
            '/contact-us': (context) => const ContactUsScreen(),
            '/delete-account': (context) => const DeleteAccountScreen(),
            '/conducteur-register': (context) =>
                const ConducteurRegisterScreen(),
          },
        );
      },
    );
  }
}
