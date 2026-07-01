import 'package:translator/translator.dart';

class TranslationService {
  final translator = GoogleTranslator();

  Future<String> translateText(String text, String lang) async {
    if (lang == 'en') return text;

    final translated = await translator.translate(text, to: lang);
    return translated.text;
  }
}
