import 'package:ashokgold_scheme_app/features/home/models/banner_model.dart';
import 'package:ashokgold_scheme_app/features/home/repository/banner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bannersProvider =
    AutoDisposeAsyncNotifierProvider<BannersNotifier, List<BannerModel>>(
      BannersNotifier.new,
    );

class BannersNotifier extends AutoDisposeAsyncNotifier<List<BannerModel>> {
  @override
  Future<List<BannerModel>> build() async {
    final repo = ref.watch(bannerRepositoryProvider);

    final result = await repo.fetchBannersApp();

    return result.fold(
      (failure) => throw Exception(failure.errMSg),
      (data) => data,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => build());
  }
}
