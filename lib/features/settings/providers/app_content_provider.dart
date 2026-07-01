import 'package:ashokgold_scheme_app/features/settings/models/app_content_model.dart';
import 'package:ashokgold_scheme_app/features/settings/repository/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final privacyPolicyProvider =
    AutoDisposeAsyncNotifierProvider<PrivacyPolicyNotifier, AppContentModel>(
      PrivacyPolicyNotifier.new,
    );

class PrivacyPolicyNotifier extends AutoDisposeAsyncNotifier<AppContentModel> {
  @override
  Future<AppContentModel> build() async {
    final res = await ref.read(settingsRepositoryProvider).fetchPrivacyPolicy();
    return res.fold((l) => throw Exception(l.errMSg), (data) => data);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final termsAndConditionsProvider =
    AutoDisposeAsyncNotifierProvider<
      TermsAndConditionsNotifier,
      AppContentModel
    >(TermsAndConditionsNotifier.new);

class TermsAndConditionsNotifier
    extends AutoDisposeAsyncNotifier<AppContentModel> {
  @override
  Future<AppContentModel> build() async {
    final res = await ref
        .read(settingsRepositoryProvider)
        .fetchTermsAndConditions();
    return res.fold((l) => throw Exception(l.errMSg), (data) => data);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
