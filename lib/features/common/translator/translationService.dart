import 'package:flutter/foundation.dart';
import 'package:translator/translator.dart';

class TranslationService {
  final translator = GoogleTranslator();

  Future<String> translateText(String text, String lang) async {
    // Sanitize language code to avoid country/region suffixes (e.g. 'ml_IN' -> 'ml')
    var targetLang = lang.trim().toLowerCase();
    if (targetLang.contains('_')) {
      targetLang = targetLang.split('_').first;
    }
    if (targetLang.contains('-')) {
      targetLang = targetLang.split('-').first;
    }

    if (targetLang == 'en' || targetLang.isEmpty) return text;

    try {
      final translated = await translator.translate(text, to: targetLang);
      return translated.text;
    } catch (e) {
      debugPrint('Translation error for "$targetLang": $e');
      return text; // Graceful fallback to original text
    }
  }
}
