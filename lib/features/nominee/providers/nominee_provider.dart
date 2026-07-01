import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/nominee/repository/nominee_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nomineeListProvider =
    AutoDisposeAsyncNotifierProvider<
      NomineeListNotifier,
      List<CustomerNomineeModel>
    >(NomineeListNotifier.new);

class NomineeListNotifier
    extends AutoDisposeAsyncNotifier<List<CustomerNomineeModel>> {
  @override
  Future<List<CustomerNomineeModel>> build() async {
    final customer = ref.read(customerProvider);
    if (customer == null) {
      throw Exception('Customer not found');
    }

    return fetchNominees();
  }

  Future<List<CustomerNomineeModel>> fetchNominees() async {
    final res = await ref
        .read(nomineeRepositoryProvider)
        .getNomineesByCustomerId();
    return res.fold((l) => throw Exception(l.errMSg), (r) => r);
  }

  Future<void> refreshList() async {
    final customer = ref.read(customerProvider);
    if (customer == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchNominees());
  }

  CustomerNomineeModel? getNomineeById(String nomineeId) {
    final currentState = state.valueOrNull;
    if (currentState == null) return null;

    try {
      return currentState.firstWhere(
        (nominee) => nominee.nomineeId == nomineeId,
      );
    } catch (e) {
      return null;
    }
  }
}
