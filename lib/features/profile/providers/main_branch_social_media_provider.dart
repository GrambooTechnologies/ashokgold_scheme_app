import 'package:ashokgold_scheme_app/features/common/models/branch_social_media_model.dart';
import 'package:ashokgold_scheme_app/features/common/repository/branch_social_media_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedSocialMediaProvider =
    StateProvider.autoDispose<BranchSocialMediaModel?>((ref) => null);

final mainBranchSocialMediaProvider =
    AutoDisposeAsyncNotifierProvider<
      MainBranchSocialMediaNotifier,
      List<BranchSocialMediaModel>
    >(() => MainBranchSocialMediaNotifier());

class MainBranchSocialMediaNotifier
    extends AutoDisposeAsyncNotifier<List<BranchSocialMediaModel>> {
  @override
  Future<List<BranchSocialMediaModel>> build() async {
    return fetchMainBranchSocialMedia();
  }

  Future<List<BranchSocialMediaModel>> fetchMainBranchSocialMedia() async {
    final res = await ref
        .read(branchSocialMediaRepositoryProvider)
        .fetchMainBranchSocialMedia();

    return res.fold((l) => throw Exception(l.errMSg), (data) => data);
  }

  void selectSocialMedia(BranchSocialMediaModel item) {
    ref.read(selectedSocialMediaProvider.notifier).state = item;
  }

  void clearSelection() {
    ref.read(selectedSocialMediaProvider.notifier).state = null;
  }
}
