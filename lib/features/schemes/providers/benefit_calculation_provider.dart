import 'package:ashokgold_scheme_app/features/schemes/models/benefit_calculation_params.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_benefit_calculation_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/repository/scheme_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final benefitCalculationProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      BenefitCalculationNotifier,
      SchemeBenefitCalculationModel,
      BenefitCalculationParams
    >(BenefitCalculationNotifier.new);

class BenefitCalculationNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<
          SchemeBenefitCalculationModel,
          BenefitCalculationParams
        > {
  @override
  Future<SchemeBenefitCalculationModel> build(
    BenefitCalculationParams arg,
  ) async {
    final repository = ref.watch(schemeRepositoryProvider);
    final result = await repository.calculateBenefit(
      schemeId: arg.schemeId,
      installmentAmount: arg.installmentAmount,
    );

    return result.fold(
      (failure) => throw Exception(failure.errMSg),
      (benefit) => benefit,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
