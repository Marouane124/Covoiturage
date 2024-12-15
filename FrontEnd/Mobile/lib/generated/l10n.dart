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

  /// `Select transport`
  String get select_transport {
    return Intl.message(
      'Select transport',
      name: 'select_transport',
      desc: '',
      args: [],
    );
  }

  /// `Select your transport`
  String get select_your_transport {
    return Intl.message(
      'Select your transport',
      name: 'select_your_transport',
      desc: '',
      args: [],
    );
  }

  /// `Car`
  String get car {
    return Intl.message(
      'Car',
      name: 'car',
      desc: '',
      args: [],
    );
  }

  /// `Bike`
  String get bike {
    return Intl.message(
      'Bike',
      name: 'bike',
      desc: '',
      args: [],
    );
  }

  /// `Cycle`
  String get cycle {
    return Intl.message(
      'Cycle',
      name: 'cycle',
      desc: '',
      args: [],
    );
  }

  /// `Taxi`
  String get taxi {
    return Intl.message(
      'Taxi',
      name: 'taxi',
      desc: '',
      args: [],
    );
  }

  /// `Available cars for ride`
  String get available_cars_for_ride {
    return Intl.message(
      'Available cars for ride',
      name: 'available_cars_for_ride',
      desc: '',
      args: [],
    );
  }

  /// `cars found`
  String get cars_found {
    return Intl.message(
      'cars found',
      name: 'cars_found',
      desc: '',
      args: [],
    );
  }

  /// `View car list`
  String get view_car_list {
    return Intl.message(
      'View car list',
      name: 'view_car_list',
      desc: '',
      args: [],
    );
  }

  /// `Automatic`
  String get automatic {
    return Intl.message(
      'Automatic',
      name: 'automatic',
      desc: '',
      args: [],
    );
  }

  /// `seats`
  String get seats {
    return Intl.message(
      'seats',
      name: 'seats',
      desc: '',
      args: [],
    );
  }

  /// `Octane`
  String get octane {
    return Intl.message(
      'Octane',
      name: 'octane',
      desc: '',
      args: [],
    );
  }

  /// `km away`
  String get km_away {
    return Intl.message(
      'km away',
      name: 'km_away',
      desc: '',
      args: [],
    );
  }

  /// `View car details`
  String get view_car_details {
    return Intl.message(
      'View car details',
      name: 'view_car_details',
      desc: '',
      args: [],
    );
  }

  /// `Specifications`
  String get specifications {
    return Intl.message(
      'Specifications',
      name: 'specifications',
      desc: '',
      args: [],
    );
  }

  /// `Car features`
  String get car_features {
    return Intl.message(
      'Car features',
      name: 'car_features',
      desc: '',
      args: [],
    );
  }

  /// `Max power`
  String get max_power {
    return Intl.message(
      'Max power',
      name: 'max_power',
      desc: '',
      args: [],
    );
  }

  /// `Fuel`
  String get fuel {
    return Intl.message(
      'Fuel',
      name: 'fuel',
      desc: '',
      args: [],
    );
  }

  /// `Max speed`
  String get max_speed {
    return Intl.message(
      'Max speed',
      name: 'max_speed',
      desc: '',
      args: [],
    );
  }

  /// `9L/100km`
  String get per_100_km {
    return Intl.message(
      '9L/100km',
      name: 'per_100_km',
      desc: '',
      args: [],
    );
  }

  /// `Model`
  String get model {
    return Intl.message(
      'Model',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  /// `Capacity`
  String get capacity {
    return Intl.message(
      'Capacity',
      name: 'capacity',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get red {
    return Intl.message(
      'Red',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `Fuel type`
  String get fuel_type {
    return Intl.message(
      'Fuel type',
      name: 'fuel_type',
      desc: '',
      args: [],
    );
  }

  /// `Gear type`
  String get gear_type {
    return Intl.message(
      'Gear type',
      name: 'gear_type',
      desc: '',
      args: [],
    );
  }

  /// `Book later`
  String get book_later {
    return Intl.message(
      'Book later',
      name: 'book_later',
      desc: '',
      args: [],
    );
  }

  /// `Ride Now`
  String get ride_now {
    return Intl.message(
      'Ride Now',
      name: 'ride_now',
      desc: '',
      args: [],
    );
  }

  /// `reviews`
  String get reviews {
    return Intl.message(
      'reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Request for rent`
  String get request_for_rent {
    return Intl.message(
      'Request for rent',
      name: 'request_for_rent',
      desc: '',
      args: [],
    );
  }

  /// `Current location`
  String get current_location {
    return Intl.message(
      'Current location',
      name: 'current_location',
      desc: '',
      args: [],
    );
  }

  /// `Office`
  String get office {
    return Intl.message(
      'Office',
      name: 'office',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Select payment method`
  String get select_payment_method {
    return Intl.message(
      'Select payment method',
      name: 'select_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Booking`
  String get confirm_booking {
    return Intl.message(
      'Confirm Booking',
      name: 'confirm_booking',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Thank you`
  String get thank_you {
    return Intl.message(
      'Thank you',
      name: 'thank_you',
      desc: '',
      args: [],
    );
  }

  /// `Your booking has been placed and is sent to driver`
  String get booking_success_message {
    return Intl.message(
      'Your booking has been placed and is sent to driver',
      name: 'booking_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Ride`
  String get confirm_ride {
    return Intl.message(
      'Confirm Ride',
      name: 'confirm_ride',
      desc: '',
      args: [],
    );
  }

  /// `Charge`
  String get charge {
    return Intl.message(
      'Charge',
      name: 'charge',
      desc: '',
      args: [],
    );
  }

  /// `Mustang`
  String get mustang {
    return Intl.message(
      'Mustang',
      name: 'mustang',
      desc: '',
      args: [],
    );
  }

  /// `VAT tax`
  String get vat {
    return Intl.message(
      'VAT tax',
      name: 'vat',
      desc: '',
      args: [],
    );
  }

  /// `Please upload both front and back license images`
  String get please_upload_license_images {
    return Intl.message(
      'Please upload both front and back license images',
      name: 'please_upload_license_images',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get account_settings {
    return Intl.message(
      'Account Settings',
      name: 'account_settings',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get change_password {
    return Intl.message(
      'Change Password',
      name: 'change_password',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get change_language {
    return Intl.message(
      'Change Language',
      name: 'change_language',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications_settings {
    return Intl.message(
      'Notifications',
      name: 'notifications_settings',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get help_support {
    return Intl.message(
      'Help & Support',
      name: 'help_support',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get terms_conditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get about_us {
    return Intl.message(
      'About Us',
      name: 'about_us',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get delete_account_confirmation {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'delete_account_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone`
  String get delete_account_warning {
    return Intl.message(
      'This action cannot be undone',
      name: 'delete_account_warning',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Delete`
  String get yes_delete {
    return Intl.message(
      'Yes, Delete',
      name: 'yes_delete',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get current_password {
    return Intl.message(
      'Current Password',
      name: 'current_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get new_password {
    return Intl.message(
      'New Password',
      name: 'new_password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirm_new_password {
    return Intl.message(
      'Confirm New Password',
      name: 'confirm_new_password',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get password_requirements {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'password_requirements',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwords_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'passwords_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get password_changed_success {
    return Intl.message(
      'Password changed successfully',
      name: 'password_changed_success',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `Language changed successfully`
  String get language_changed_success {
    return Intl.message(
      'Language changed successfully',
      name: 'language_changed_success',
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
