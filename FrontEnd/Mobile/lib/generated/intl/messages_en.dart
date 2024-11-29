// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "error_gender_required":
            MessageLookupByLibrary.simpleMessage("Please select a gender"),
        "error_invalid_email":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "error_password_short": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 6 characters"),
        "error_phone_required":
            MessageLookupByLibrary.simpleMessage("Phone number is required"),
        "error_role_required":
            MessageLookupByLibrary.simpleMessage("Please select a role"),
        "error_username_required":
            MessageLookupByLibrary.simpleMessage("Username is required"),
        "login_screen_email":
            MessageLookupByLibrary.simpleMessage("Email or Phone Number"),
        "login_screen_empty_fields":
            MessageLookupByLibrary.simpleMessage("Please fill in all fields"),
        "login_screen_forgot_password":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "login_screen_login_failed": MessageLookupByLibrary.simpleMessage(
            "Login failed. Please try again."),
        "login_screen_login_success":
            MessageLookupByLibrary.simpleMessage("Login successful!"),
        "login_screen_or": MessageLookupByLibrary.simpleMessage("or"),
        "login_screen_password":
            MessageLookupByLibrary.simpleMessage("Enter Your Password"),
        "login_screen_signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
        "login_screen_signUp": MessageLookupByLibrary.simpleMessage(
            "Don\'t have an account? Sign Up"),
        "login_screen_sign_in_with_apple":
            MessageLookupByLibrary.simpleMessage("Sign in with Apple"),
        "login_screen_sign_in_with_facebook":
            MessageLookupByLibrary.simpleMessage("Sign in with Facebook"),
        "login_screen_sign_in_with_google":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "login_screen_title": MessageLookupByLibrary.simpleMessage("Sign in"),
        "login_screen_username":
            MessageLookupByLibrary.simpleMessage("Username"),
        "register_screen_email": MessageLookupByLibrary.simpleMessage("Email"),
        "register_screen_error":
            MessageLookupByLibrary.simpleMessage("Registration failed"),
        "register_screen_gender":
            MessageLookupByLibrary.simpleMessage("Gender"),
        "register_screen_name": MessageLookupByLibrary.simpleMessage("Name"),
        "register_screen_or": MessageLookupByLibrary.simpleMessage("or"),
        "register_screen_password":
            MessageLookupByLibrary.simpleMessage("Password"),
        "register_screen_phone":
            MessageLookupByLibrary.simpleMessage("Phone Number"),
        "register_screen_role":
            MessageLookupByLibrary.simpleMessage("Select Role"),
        "register_screen_signUp":
            MessageLookupByLibrary.simpleMessage("Sign Up"),
        "register_screen_sign_up_with_apple":
            MessageLookupByLibrary.simpleMessage("Sign up with Apple"),
        "register_screen_sign_up_with_facebook":
            MessageLookupByLibrary.simpleMessage("Sign up with Facebook"),
        "register_screen_sign_up_with_google":
            MessageLookupByLibrary.simpleMessage("Sign up with Google"),
        "register_screen_success":
            MessageLookupByLibrary.simpleMessage("Registration successful"),
        "register_screen_title":
            MessageLookupByLibrary.simpleMessage("Sign up"),
        "welcome_screen_message": MessageLookupByLibrary.simpleMessage(
            "Have a better sharing experience"),
        "welcome_screen_signIn": MessageLookupByLibrary.simpleMessage("Log In"),
        "welcome_screen_signUp":
            MessageLookupByLibrary.simpleMessage("Create an account"),
        "welcome_screen_title": MessageLookupByLibrary.simpleMessage("Welcome")
      };
}
