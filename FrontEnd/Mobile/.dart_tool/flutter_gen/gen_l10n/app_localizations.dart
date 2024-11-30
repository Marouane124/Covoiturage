import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @welcome_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome_screen_title;

  /// No description provided for @welcome_screen_message.
  ///
  /// In en, this message translates to:
  /// **'Have a better sharing experience'**
  String get welcome_screen_message;

  /// No description provided for @welcome_screen_signUp.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get welcome_screen_signUp;

  /// No description provided for @welcome_screen_signIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get welcome_screen_signIn;

  /// No description provided for @login_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_screen_title;

  /// No description provided for @login_screen_email.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get login_screen_email;

  /// No description provided for @login_screen_password.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get login_screen_password;

  /// No description provided for @login_screen_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get login_screen_forgot_password;

  /// No description provided for @login_screen_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login_screen_signIn;

  /// No description provided for @login_screen_or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get login_screen_or;

  /// No description provided for @login_screen_sign_in_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get login_screen_sign_in_with_google;

  /// No description provided for @login_screen_sign_in_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get login_screen_sign_in_with_facebook;

  /// No description provided for @login_screen_sign_in_with_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get login_screen_sign_in_with_apple;

  /// No description provided for @login_screen_signUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get login_screen_signUp;

  /// No description provided for @register_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register_screen_title;

  /// No description provided for @register_screen_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get register_screen_name;

  /// No description provided for @register_screen_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get register_screen_email;

  /// No description provided for @register_screen_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get register_screen_phone;

  /// No description provided for @register_screen_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get register_screen_gender;

  /// No description provided for @register_screen_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get register_screen_signUp;

  /// No description provided for @register_screen_or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get register_screen_or;

  /// No description provided for @register_screen_sign_up_with_google.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get register_screen_sign_up_with_google;

  /// No description provided for @register_screen_sign_up_with_facebook.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Facebook'**
  String get register_screen_sign_up_with_facebook;

  /// No description provided for @register_screen_sign_up_with_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get register_screen_sign_up_with_apple;

  /// No description provided for @become_driver_title.
  ///
  /// In en, this message translates to:
  /// **'Become a Driver'**
  String get become_driver_title;

  /// No description provided for @become_driver_message.
  ///
  /// In en, this message translates to:
  /// **'Would you like to become a driver?'**
  String get become_driver_message;

  /// No description provided for @become_driver.
  ///
  /// In en, this message translates to:
  /// **'Become a Driver'**
  String get become_driver;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @register_screen_city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get register_screen_city;

  /// No description provided for @driver_registration.
  ///
  /// In en, this message translates to:
  /// **'Driver Registration'**
  String get driver_registration;

  /// No description provided for @license_number.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get license_number;

  /// No description provided for @vehicle_model.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicle_model;

  /// No description provided for @vehicle_year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get vehicle_year;

  /// No description provided for @license_plate.
  ///
  /// In en, this message translates to:
  /// **'License Plate Number'**
  String get license_plate;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required_field;

  /// No description provided for @invalid_year.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid year'**
  String get invalid_year;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @leave_registration_title.
  ///
  /// In en, this message translates to:
  /// **'Leave Registration'**
  String get leave_registration_title;

  /// No description provided for @leave_registration_message.
  ///
  /// In en, this message translates to:
  /// **'If you leave now, all entered information will be lost. Are you sure you want to leave?'**
  String get leave_registration_message;

  /// No description provided for @continue_registration.
  ///
  /// In en, this message translates to:
  /// **'Continue Registration'**
  String get continue_registration;

  /// No description provided for @leave_page.
  ///
  /// In en, this message translates to:
  /// **'Leave Page'**
  String get leave_page;

  /// No description provided for @license_images.
  ///
  /// In en, this message translates to:
  /// **'License Images'**
  String get license_images;

  /// No description provided for @license_front.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get license_front;

  /// No description provided for @license_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get license_back;

  /// No description provided for @phone_verification.
  ///
  /// In en, this message translates to:
  /// **'Phone verification'**
  String get phone_verification;

  /// No description provided for @enter_otp_code.
  ///
  /// In en, this message translates to:
  /// **'Enter your OTP code'**
  String get enter_otp_code;

  /// No description provided for @didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didnt_receive_code;

  /// No description provided for @resend_again.
  ///
  /// In en, this message translates to:
  /// **'Resend again'**
  String get resend_again;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
