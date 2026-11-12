import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbit_workforce/lang/ar.dart';
import 'package:orbit_workforce/lang/en.dart';

class TranslationService extends Translations {
  // List of supported locales
  static String getCurrentLanguage() {
    return Get.locale?.languageCode ??
        'en'; // إعادة اللغة الحالية أو الإنجليزية افتراضيًا
  }

  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('ar', 'EG'),
  ];

  // Default locale
  static Locale get fallbackLocale => const Locale('en', 'US');

  // Define the translations for each language
  @override
  Map<String, Map<String, String>> get keys => {'en_US': en, 'ar_EG': ar};

  // Method to switch between languages
  static void changeLocale(String languageCode) {
    Locale locale = _getLocaleFromLanguage(languageCode);
    Get.updateLocale(locale);
  }

  // Helper method to get Locale from language code
  static Locale _getLocaleFromLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return const Locale('en', 'US');
      case 'ar':
        return const Locale('ar', 'EG');
      default:
        return fallbackLocale;
    }
  }

  // Method to get the flag image for the selected language
  static String getFlagForLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        // Image.asset('assets/setting.png'),
        return 'assets/images/FlagUnitedKingdom.png'; // English flag
      case 'ar':
        return 'assets/images/FlagsaudiArabia.png'; // Saudi Arabian flag
      default:
        return 'assets/images/FlagUnitedKingdom.png'; // Default to English flag
    }
  }

  // Method to get the displayed language text
  static String getLanguageText(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'عربي';
      default:
        return 'English'; // Default to English
    }
  }
}
