import 'package:ashokgold_scheme_app/features/common/models/dropdown_model.dart';
import 'package:ashokgold_scheme_app/features/common/repository/dropdown_repository.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider for selected nominee relation
final selectedNomineeRelationProvider =
    StateProvider.autoDispose<DropdownItemModel?>((ref) => null);

// Provider for fetching nominee relations
final nomineeRelationsListProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      NomineeRelationsListNotifier,
      List<DropdownItemModel>,
      CustomerNomineeModel?
    >(() => NomineeRelationsListNotifier());

class NomineeRelationsListNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          List<DropdownItemModel>,
          CustomerNomineeModel?
        > {
  @override
  Future<List<DropdownItemModel>> build(CustomerNomineeModel? nominee) async {
    return fetchNomineeRelations(nominee: nominee);
  }

  Future<List<DropdownItemModel>> fetchNomineeRelations({
    CustomerNomineeModel? nominee,
  }) async {
    final res = await ref
        .read(dropdownRepositoryProvider)
        .fetchNomineeRelations();
    return res.fold((l) => throw Exception(l.errMSg), (relations) {
      if (nominee?.nomineeRelation != null) {
        final matchingRelation = relations.where(
          (relation) => relation.id == nominee!.nomineeRelation.relationId,
        );
        if (matchingRelation.isNotEmpty) {
          ref
              .read(selectedNomineeRelationProvider.notifier)
              .update((state) => matchingRelation.first);
        }
      }
      return relations;
    });
  }
}
