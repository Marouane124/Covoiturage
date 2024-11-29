import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_screen_title => 'Welcome';

  @override
  String get welcome_screen_message => 'Have a better sharing experience';

  @override
  String get welcome_screen_signUp => 'Create an account';

  @override
  String get welcome_screen_signIn => 'Log In';

  @override
  String get login_screen_title => 'Sign in';

  @override
  String get login_screen_email => 'Email or Phone Number';

  @override
  String get login_screen_password => 'Enter Your Password';

  @override
  String get login_screen_forgot_password => 'Forgot Password?';

  @override
  String get login_screen_signIn => 'Sign In';

  @override
  String get login_screen_or => 'or';

  @override
  String get login_screen_sign_in_with_google => 'Sign in with Google';

  @override
  String get login_screen_sign_in_with_facebook => 'Sign in with Facebook';

  @override
  String get login_screen_sign_in_with_apple => 'Sign in with Apple';

  @override
  String get login_screen_signUp => 'Don\'t have an account? Sign Up';

  @override
  String get register_screen_title => 'Sign up';

  @override
  String get register_screen_name => 'Name';

  @override
  String get register_screen_email => 'Email';

  @override
  String get register_screen_password => 'Password';

  @override
  String get register_screen_phone => 'Phone Number';

  @override
  String get register_screen_gender => 'Gender';

  @override
  String get register_screen_signUp => 'Sign Up';

  @override
  String get register_screen_or => 'or';

  @override
  String get register_screen_sign_up_with_google => 'Sign up with Google';

  @override
  String get register_screen_sign_up_with_facebook => 'Sign up with Facebook';

  @override
  String get register_screen_sign_up_with_apple => 'Sign up with Apple';

  @override
  String get error_username_required => 'Username is required';

  @override
  String get error_invalid_email => 'Please enter a valid email';

  @override
  String get error_phone_required => 'Phone number is required';

  @override
  String get error_password_short => 'Password must be at least 6 characters';

  @override
  String get error_gender_required => 'Please select a gender';

  @override
  String get error_role_required => 'Please select a role';

  @override
  String get register_screen_success => 'Registration successful';

  @override
  String get register_screen_error => 'Registration failed';

  @override
  String get login_screen_empty_fields => 'Please fill in all fields';

  @override
  String get login_screen_username => 'Username';

  @override
  String get login_screen_login_success => 'Login successful!';

  @override
  String get login_screen_login_failed => 'Login failed. Please try again.';

  @override
  String get register_screen_role => 'Select Role';
}
