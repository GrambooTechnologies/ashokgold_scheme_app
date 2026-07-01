import 'package:ashokgold_scheme_app/features/common/models/metal_rate_model.dart';
import 'package:ashokgold_scheme_app/features/common/repository/metal_rate_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final latestMetalRateProvider =
    AutoDisposeAsyncNotifierProvider<LatestMetalRateNotifier, MetalRateModel>(
      LatestMetalRateNotifier.new,
    );

class LatestMetalRateNotifier extends AutoDisposeAsyncNotifier<MetalRateModel> {
  @override
  Future<MetalRateModel> build() async {
    final repo = ref.watch(metalRateRepositoryProvider);

    final result = await repo.fetchLatestMetalRate();

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
