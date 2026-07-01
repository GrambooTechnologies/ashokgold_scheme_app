import 'package:ashokgold_scheme_app/features/common/translator/translationService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final translationServiceProvider = Provider<TranslationService>((ref) {
  return TranslationService();
});
