import 'package:ashokgold_scheme_app/features/schemes/models/scheme_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/repository/scheme_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemesListProvider =
    AutoDisposeAsyncNotifierProvider<SchemesListNotifier, List<SchemeModel>>(
      SchemesListNotifier.new,
    );

class SchemesListNotifier extends AutoDisposeAsyncNotifier<List<SchemeModel>> {
  @override
  Future<List<SchemeModel>> build() async {
    return fetchSchemes();
  }

  Future<List<SchemeModel>> fetchSchemes() async {
    final res = await ref.read(schemeRepositoryProvider).getAllSchemes();
    return res.fold((l) => throw Exception(l.errMSg), (r) => r);
  }

  Future<void> refreshList() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchSchemes());
  }

  SchemeModel? getSchemeById(String schemeId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return null;

    try {
      return currentState.firstWhere((scheme) => scheme.schemeId == schemeId);
    } catch (e) {
      return null;
    }
  }
}
