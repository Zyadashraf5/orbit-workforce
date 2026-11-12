import 'package:get/get.dart';
import 'package:orbit_workforce/lang/translation.dart';

class LanguageController extends GetxController {
  String selectedLanguage = 'en';

  String get flagImage => TranslationService.getFlagForLanguage('en');

  String get flagImages => TranslationService.getFlagForLanguage('ar');

  void changeLanguage(String languageCode) {
    selectedLanguage = languageCode;

    TranslationService.changeLocale(languageCode);

    update();
  }
}
