import 'package:ashokgold_scheme_app/features/common/models/branch_model.dart';
import 'package:ashokgold_scheme_app/features/common/repository/branch_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider for selected branch
final selectedBranchProvider = StateProvider.autoDispose<BranchModel?>(
  (ref) => null,
);

// Provider for fetching branches
final branchesListProvider =
    AutoDisposeAsyncNotifierProvider<BranchesListNotifier, List<BranchModel>>(
      () => BranchesListNotifier(),
    );

class BranchesListNotifier extends AutoDisposeAsyncNotifier<List<BranchModel>> {
  @override
  Future<List<BranchModel>> build() async {
    return fetchBranches();
  }

  Future<List<BranchModel>> fetchBranches() async {
    final res = await ref.read(branchRepositoryProvider).fetchAllBranches();
    return res.fold((l) => throw Exception(l.errMSg), (branches) => branches);
  }

  void selectBranch(BranchModel branch) {
    ref.read(selectedBranchProvider.notifier).state = branch;
  }

  void clearSelection() {
    ref.read(selectedBranchProvider.notifier).state = null;
  }
}
