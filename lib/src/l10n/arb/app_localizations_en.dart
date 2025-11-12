// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get wordContinue => 'Continue';

  @override
  String get noConfigImportedText =>
      'To connect to unrestricted internet,\nyou need a config link or json config.';

  @override
  String get wordImport => 'Import';

  @override
  String get wordSubmit => 'Submit';

  @override
  String get neverMind => 'Never mind';

  @override
  String get checkInternetConnection =>
      'Check your internet connection status !';

  @override
  String get slideToDisconnect => 'Slide to disconnect';

  @override
  String get activeTimeText => 'ACTIVE TIME';

  @override
  String get addYourConfig => 'Add your config';

  @override
  String get hasActiveSub_MainScreen =>
      'To improve the connection conditions, \nyou can always import another config.';

  @override
  String get anErrorHappened => 'An error happened';
}
