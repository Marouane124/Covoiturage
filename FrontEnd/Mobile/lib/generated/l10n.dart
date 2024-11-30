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

  /// `Password`
  String get register_screen_password {
    return Intl.message(
      'Password',
      name: 'register_screen_password',
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

  /// `Become a Driver`
  String get become_driver_title {
    return Intl.message(
      'Become a Driver',
      name: 'become_driver_title',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to become a driver?`
  String get become_driver_message {
    return Intl.message(
      'Would you like to become a driver?',
      name: 'become_driver_message',
      desc: '',
      args: [],
    );
  }

  /// `Become a Driver`
  String get become_driver {
    return Intl.message(
      'Become a Driver',
      name: 'become_driver',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get register_screen_city {
    return Intl.message(
      'City',
      name: 'register_screen_city',
      desc: '',
      args: [],
    );
  }

  /// `Driver Registration`
  String get driver_registration {
    return Intl.message(
      'Driver Registration',
      name: 'driver_registration',
      desc: '',
      args: [],
    );
  }

  /// `License Number`
  String get license_number {
    return Intl.message(
      'License Number',
      name: 'license_number',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Model`
  String get vehicle_model {
    return Intl.message(
      'Vehicle Model',
      name: 'vehicle_model',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get vehicle_year {
    return Intl.message(
      'Year',
      name: 'vehicle_year',
      desc: '',
      args: [],
    );
  }

  /// `License Plate Number`
  String get license_plate {
    return Intl.message(
      'License Plate Number',
      name: 'license_plate',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get required_field {
    return Intl.message(
      'This field is required',
      name: 'required_field',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid year`
  String get invalid_year {
    return Intl.message(
      'Please enter a valid year',
      name: 'invalid_year',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Leave Registration`
  String get leave_registration_title {
    return Intl.message(
      'Leave Registration',
      name: 'leave_registration_title',
      desc: '',
      args: [],
    );
  }

  /// `If you leave now, all entered information will be lost. Are you sure you want to leave?`
  String get leave_registration_message {
    return Intl.message(
      'If you leave now, all entered information will be lost. Are you sure you want to leave?',
      name: 'leave_registration_message',
      desc: '',
      args: [],
    );
  }

  /// `Continue Registration`
  String get continue_registration {
    return Intl.message(
      'Continue Registration',
      name: 'continue_registration',
      desc: '',
      args: [],
    );
  }

  /// `Leave Page`
  String get leave_page {
    return Intl.message(
      'Leave Page',
      name: 'leave_page',
      desc: '',
      args: [],
    );
  }

  /// `License Images`
  String get license_images {
    return Intl.message(
      'License Images',
      name: 'license_images',
      desc: '',
      args: [],
    );
  }

  /// `Front`
  String get license_front {
    return Intl.message(
      'Front',
      name: 'license_front',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get license_back {
    return Intl.message(
      'Back',
      name: 'license_back',
      desc: '',
      args: [],
    );
  }

  /// `Phone verification`
  String get phone_verification {
    return Intl.message(
      'Phone verification',
      name: 'phone_verification',
      desc: '',
      args: [],
    );
  }

  /// `Enter your OTP code`
  String get enter_otp_code {
    return Intl.message(
      'Enter your OTP code',
      name: 'enter_otp_code',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive code?`
  String get didnt_receive_code {
    return Intl.message(
      'Didn\'t receive code?',
      name: 'didnt_receive_code',
      desc: '',
      args: [],
    );
  }

  /// `Resend again`
  String get resend_again {
    return Intl.message(
      'Resend again',
      name: 'resend_again',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Username is required`
  String get error_username_required {
    return Intl.message(
      'Username is required',
      name: 'error_username_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get error_invalid_email {
    return Intl.message(
      'Please enter a valid email',
      name: 'error_invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get error_phone_required {
    return Intl.message(
      'Phone number is required',
      name: 'error_phone_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get error_password_short {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'error_password_short',
      desc: '',
      args: [],
    );
  }

  /// `Please select a gender`
  String get error_gender_required {
    return Intl.message(
      'Please select a gender',
      name: 'error_gender_required',
      desc: '',
      args: [],
    );
  }

  /// `Please select a role`
  String get error_role_required {
    return Intl.message(
      'Please select a role',
      name: 'error_role_required',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get register_screen_success {
    return Intl.message(
      'Registration successful',
      name: 'register_screen_success',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed`
  String get register_screen_error {
    return Intl.message(
      'Registration failed',
      name: 'register_screen_error',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get login_screen_empty_fields {
    return Intl.message(
      'Please fill in all fields',
      name: 'login_screen_empty_fields',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get login_screen_username {
    return Intl.message(
      'Username',
      name: 'login_screen_username',
      desc: '',
      args: [],
    );
  }

  /// `Login successful!`
  String get login_screen_login_success {
    return Intl.message(
      'Login successful!',
      name: 'login_screen_login_success',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. Please try again.`
  String get login_screen_login_failed {
    return Intl.message(
      'Login failed. Please try again.',
      name: 'login_screen_login_failed',
      desc: '',
      args: [],
    );
  }

  /// `Select Role`
  String get register_screen_role {
    return Intl.message(
      'Select Role',
      name: 'register_screen_role',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get gender_male {
    return Intl.message(
      'Male',
      name: 'gender_male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get gender_female {
    return Intl.message(
      'Female',
      name: 'gender_female',
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
