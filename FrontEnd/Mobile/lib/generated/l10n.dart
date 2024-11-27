// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome`
  String get welcome_screen_title {
    return Intl.message(
      'Welcome',
      name: 'welcome_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Have a better sharing experience`
  String get welcome_screen_message {
    return Intl.message(
      'Have a better sharing experience',
      name: 'welcome_screen_message',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get welcome_screen_signUp {
    return Intl.message(
      'Create an account',
      name: 'welcome_screen_signUp',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get welcome_screen_signIn {
    return Intl.message(
      'Log In',
      name: 'welcome_screen_signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get login_screen_title {
    return Intl.message(
      'Sign in',
      name: 'login_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone Number`
  String get login_screen_email {
    return Intl.message(
      'Email or Phone Number',
      name: 'login_screen_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get login_screen_password {
    return Intl.message(
      'Enter Your Password',
      name: 'login_screen_password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get login_screen_forgot_password {
    return Intl.message(
      'Forgot Password?',
      name: 'login_screen_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get login_screen_signIn {
    return Intl.message(
      'Sign In',
      name: 'login_screen_signIn',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get login_screen_or {
    return Intl.message(
      'or',
      name: 'login_screen_or',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get login_screen_sign_in_with_google {
    return Intl.message(
      'Sign in with Google',
      name: 'login_screen_sign_in_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Facebook`
  String get login_screen_sign_in_with_facebook {
    return Intl.message(
      'Sign in with Facebook',
      name: 'login_screen_sign_in_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get login_screen_sign_in_with_apple {
    return Intl.message(
      'Sign in with Apple',
      name: 'login_screen_sign_in_with_apple',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Sign Up`
  String get login_screen_signUp {
    return Intl.message(
      'Don\'t have an account? Sign Up',
      name: 'login_screen_signUp',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get register_screen_title {
    return Intl.message(
      'Sign up',
      name: 'register_screen_title',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get register_screen_name {
    return Intl.message(
      'Name',
      name: 'register_screen_name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get register_screen_email {
    return Intl.message(
      'Email',
      name: 'register_screen_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get register_screen_phone {
    return Intl.message(
      'Phone Number',
      name: 'register_screen_phone',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get register_screen_gender {
    return Intl.message(
      'Gender',
      name: 'register_screen_gender',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get register_screen_password {
    return Intl.message(
      'Password',
      name: 'register_screen_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get register_screen_confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'register_screen_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get register_screen_signUp {
    return Intl.message(
      'Sign Up',
      name: 'register_screen_signUp',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get register_screen_or {
    return Intl.message(
      'or',
      name: 'register_screen_or',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Google`
  String get register_screen_sign_up_with_google {
    return Intl.message(
      'Sign up with Google',
      name: 'register_screen_sign_up_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Facebook`
  String get register_screen_sign_up_with_facebook {
    return Intl.message(
      'Sign up with Facebook',
      name: 'register_screen_sign_up_with_facebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with Apple`
  String get register_screen_sign_up_with_apple {
    return Intl.message(
      'Sign up with Apple',
      name: 'register_screen_sign_up_with_apple',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
