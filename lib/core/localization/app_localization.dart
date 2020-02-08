import 'package:flutter/material.dart';

import 'languages/lang.dart';

class AppLocalization {
  final Locale locale;

  Map<StringKey, String> _localizedStrings;

  AppLocalization(this.locale);

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static const LocalizationsDelegate<AppLocalization> delegate = _AppLocalizationDelegate();

  Future<bool> load() async {
    _localizedStrings = getLocalizedStrings(locale.languageCode);
    return true;
  }

  String _translate(StringKey key) {
    return _localizedStrings[key];
  }

  // getters of translated texts 
  String get appTitle => _translate(StringKey.AppTitle);
  String get walkingTitle => _translate(StringKey.WalkingTitle);
  String get slowRunTitle => _translate(StringKey.SlowRunTitle);
  String get normalRunTitle => _translate(StringKey.NormalRunTitle);
  String get acceleratedRunTitle => _translate(StringKey.AcceleratedRunTitle);

  String get fabTrainingPageStartText => _translate(StringKey.TrainingPageFABStartText);
  String get fabTrainingPagePauseText => _translate(StringKey.TrainingPageFABPauseText);
  String get fabTrainingPageResumeText => _translate(StringKey.TrainingPageFABResumeText);
  String get fabTrainingPageStopText => _translate(StringKey.TrainingPageFABStopText);
  String get fabTrainingPageDoneText => _translate(StringKey.TrainingPageFABDoneText);
  String get fabTrainingPageRepeatText => _translate(StringKey.TrainingPageFABRepeatText);
}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const _AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localization = AppLocalization(locale);
    localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}