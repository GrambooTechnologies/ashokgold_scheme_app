import 'package:ashokgold_scheme_app/features/common/models/pincode_lookup_response.dart';
import 'package:ashokgold_scheme_app/features/common/repository/pincode_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pincodeDetailsProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      PincodeDetailsNotifier,
      PincodeLookupResponse,
      String
    >(PincodeDetailsNotifier.new);

class PincodeDetailsNotifier
    extends AutoDisposeFamilyAsyncNotifier<PincodeLookupResponse, String> {
  @override
  Future<PincodeLookupResponse> build(String pincode) async {
    final repository = ref.watch(pincodeRepositoryProvider);
    final result = await repository.getPincodeDetails(pincode);

    return result.fold(
      (failure) => throw Exception(failure.errMSg),
      (pincodeData) => pincodeData,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
