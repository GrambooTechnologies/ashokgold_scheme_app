import 'package:ashokgold_scheme_app/core/api_constants/app_content_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/settings/models/app_content_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(dio: ref.watch(dioProvider));
});

class SettingsRepository {
  final Dio dio;

  SettingsRepository({required this.dio});

  FutureEither<AppContentModel> fetchPrivacyPolicy() async {
    return _fetchAppContent(AppContentApis.privacyPolicy);
  }

  FutureEither<AppContentModel> fetchTermsAndConditions() async {
    return _fetchAppContent(AppContentApis.termsAndConditions);
  }

  FutureEither<AppContentModel> _fetchAppContent(String endpoint) async {
    try {
      final response = await dio.get(endpoint);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final content = AppContentModel.fromJson(res['data']);
        return right(content);
      }

      throw Exception('Failed to fetch app content');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
