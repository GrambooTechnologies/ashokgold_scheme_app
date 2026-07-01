import 'package:ashokgold_scheme_app/features/schemes/providers/scheme_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/translator/languageProvider.dart';
import '../../common/translator/translation_provider.dart';
import '../models/scheme_detail_response_model.dart';

final translatedSchemeProvider = FutureProvider.family
    .autoDispose<SchemeDetailByIdResponseModel, String>((ref, schemeId) async {
      final lang = ref.watch(languageProvider);
      final scheme = await ref.watch(schemeDetailProvider(schemeId).future);
      final service = ref.watch(translationServiceProvider);

      if (lang == 'en') return scheme;

      return scheme.copyWith(
        name: await service.translateText(scheme.name, lang),
        description: await service.translateText(
          scheme.description ?? '',
          lang,
        ),
        benefitPoints: await Future.wait(
          scheme.benefitPoints.map((e) async {
            return e.copyWith(
              benefitPointDescription: await service.translateText(
                e.benefitPointDescription,
                lang,
              ),
            );
          }),
        ),
        termsAndConditions: await Future.wait(
          scheme.termsAndConditions.map((tc) async {
            return tc.copyWith(
              termConditionDescription: await service.translateText(
                tc.termConditionDescription,
                lang,
              ),
            );
          }),
        ),
      );
    });
