import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('es')
  ];

  /// No description provided for @title_add_user.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get title_add_user;

  /// No description provided for @button_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get button_add;

  /// No description provided for @label_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get label_login;

  /// No description provided for @hint_login.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get hint_login;

  /// No description provided for @label_id.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get label_id;

  /// No description provided for @hint_id.
  ///
  /// In en, this message translates to:
  /// **'Enter user ID'**
  String get hint_id;

  /// No description provided for @label_group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get label_group;

  /// No description provided for @hint_group.
  ///
  /// In en, this message translates to:
  /// **'Enter group'**
  String get hint_group;

  /// No description provided for @label_domain.
  ///
  /// In en, this message translates to:
  /// **'Domain'**
  String get label_domain;

  /// No description provided for @hint_domain.
  ///
  /// In en, this message translates to:
  /// **'Select a domain'**
  String get hint_domain;

  /// No description provided for @label_quota.
  ///
  /// In en, this message translates to:
  /// **'Quota'**
  String get label_quota;

  /// No description provided for @hint_quota.
  ///
  /// In en, this message translates to:
  /// **'Enter quota'**
  String get hint_quota;

  /// No description provided for @label_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get label_password;

  /// No description provided for @hint_password.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get hint_password;

  /// No description provided for @label_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get label_confirm_password;

  /// No description provided for @hint_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Re-enter the password'**
  String get hint_confirm_password;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @user_added_success.
  ///
  /// In en, this message translates to:
  /// **'User added successfully'**
  String get user_added_success;

  /// No description provided for @field_required.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get field_required;

  /// No description provided for @domain_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a domain'**
  String get domain_required;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get change_language;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get select_language;

  /// No description provided for @user_management.
  ///
  /// In en, this message translates to:
  /// **'User management'**
  String get user_management;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @aliases.
  ///
  /// In en, this message translates to:
  /// **'Aliases'**
  String get aliases;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logout_question.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logout_question;

  /// No description provided for @logout_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logout_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @edit_user_title.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get edit_user_title;

  /// No description provided for @update_button.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update_button;

  /// No description provided for @delete_confirmation.
  ///
  /// In en, this message translates to:
  /// **'This will be deleted. Are you sure you want to continue?'**
  String get delete_confirmation;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel?'**
  String get cancel_confirmation;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @alias_management.
  ///
  /// In en, this message translates to:
  /// **'Alias management'**
  String get alias_management;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_title;

  /// No description provided for @success_title.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success_title;

  /// No description provided for @user_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'User added successfully'**
  String get user_added_successfully;

  /// No description provided for @alias_updated.
  ///
  /// In en, this message translates to:
  /// **'Alias updated'**
  String get alias_updated;

  /// No description provided for @user_updated.
  ///
  /// In en, this message translates to:
  /// **'User updated'**
  String get user_updated;

  /// No description provided for @alias_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Alias data was updated successfully.'**
  String get alias_updated_successfully;

  /// No description provided for @user_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'User data was updated successfully.'**
  String get user_updated_successfully;

  /// No description provided for @alias_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Alias added successfully.'**
  String get alias_added_successfully;

  /// No description provided for @edit_alias.
  ///
  /// In en, this message translates to:
  /// **'Edit alias'**
  String get edit_alias;

  /// No description provided for @add_alias.
  ///
  /// In en, this message translates to:
  /// **'Add alias'**
  String get add_alias;

  /// No description provided for @local_label.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local_label;

  /// No description provided for @local_alias_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your local alias'**
  String get local_alias_hint;

  /// No description provided for @remote_label.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remote_label;

  /// No description provided for @remote_alias_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your remote alias'**
  String get remote_alias_hint;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalid_email;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get old_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get password_updated;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
