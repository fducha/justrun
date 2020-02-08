import 'package:justrun/core/localization/languages/en_dict.dart';
import 'package:justrun/core/localization/languages/ru_dict.dart';

enum StringKey {
  AppTitle,
  WalkingTitle,
  SlowRunTitle,
  NormalRunTitle,
  AcceleratedRunTitle,

  TrainingPageFABStartText,
  TrainingPageFABPauseText,
  TrainingPageFABResumeText,
  TrainingPageFABStopText,
  TrainingPageFABDoneText,
  TrainingPageFABRepeatText,
}

Map<StringKey, String> getLocalizedStrings(String languageCode) {
  switch (languageCode) {
    case 'ru':
      return ru_dict;
    case 'en':
    default:
      return en_dict;
  }
}
