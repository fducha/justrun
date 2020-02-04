import 'package:justrun/common/localization/languages/en_dict.dart';
import 'package:justrun/common/localization/languages/ru_dict.dart';

enum StringKey {
  AppTitle,
  WalkingTitle,
  SlowRunTitle,
  NormalRunTitle,
  AcceleratedRunTitle,
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
