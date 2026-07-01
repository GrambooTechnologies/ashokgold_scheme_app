import 'package:ashokgold_scheme_app/features/scheme_joining/models/preferred_branch_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/repository/scheme_joining_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider for selected preferred branch
final selectedPreferredBranchProvider =
    StateProvider.autoDispose<PreferredBranchModel?>((ref) => null);

// Provider for fetching preferred branches based on schemeId
final preferredBranchesListForJoiningProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      PreferredBranchesListNotifier,
      List<PreferredBranchModel>,
      String
    >(() => PreferredBranchesListNotifier());

class PreferredBranchesListNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<PreferredBranchModel>, String> {
  @override
  Future<List<PreferredBranchModel>> build(String schemeId) async {
    return fetchPreferredBranches(schemeId);
  }

  Future<List<PreferredBranchModel>> fetchPreferredBranches(
    String schemeId,
  ) async {
    final res = await ref
        .read(schemeJoiningRepositoryProvider)
        .fetchPreferredBranches(schemeId);
    return res.fold((l) => throw Exception(l.errMSg), (branches) => branches);
  }

  void selectBranch(PreferredBranchModel branch) {
    ref.read(selectedPreferredBranchProvider.notifier).state = branch;
  }

  void clearSelection() {
    ref.read(selectedPreferredBranchProvider.notifier).state = null;
  }
}
