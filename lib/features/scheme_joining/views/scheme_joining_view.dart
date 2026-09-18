import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/controllers/scheme_joining_controller.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/coordinators/flow_coordinator.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/form_controllers_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/scheme_joining_form_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/services/scheme_joining_service.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/utils/initializer.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/utils/page_navigation_helper.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/utils/validation_helper.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/widgets/scheme_joining_navigation_buttons.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/widgets/step_1_branch_selection.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/widgets/step_2_billing_address.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/widgets/step_3_amount_selection.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/widgets/step_4_review_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchemeJoiningView extends ConsumerStatefulWidget {
  static const String routeName = '/scheme-joining';
  static String routePath({required String schemeId, required double? amount}) {
    final amountParam = amount != null ? '?amount=$amount' : '';
    return '/scheme-joining/$schemeId$amountParam';
  }

  final String schemeId;
  final double initialAmount;

  const SchemeJoiningView({
    super.key,
    required this.schemeId,
    required this.initialAmount,
  });

  @override
  ConsumerState<SchemeJoiningView> createState() => _SchemeJoiningViewState();
}

class _SchemeJoiningViewState extends ConsumerState<SchemeJoiningView>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  late final SchemeJoiningFlowCoordinator _flowCoordinator;
  late final AnimationController _headerAnimController;
  late final Animation<double> _headerFade;

  String? schemeId;
  late double initialAmount;

  // Step metadata
  static const _stepMeta = [
    _StepMeta(
      icon: Icons.store_outlined,
      activeIcon: Icons.store_rounded,
      label: 'Branch',
      subtitle: 'Select branch & nominee',
    ),
    _StepMeta(
      icon: Icons.location_on_outlined,
      activeIcon: Icons.location_on_rounded,
      label: 'Address',
      subtitle: 'Billing address',
    ),
    _StepMeta(
      icon: Icons.payments_outlined,
      activeIcon: Icons.payments_rounded,
      label: 'Amount',
      subtitle: 'Set installment',
    ),
    _StepMeta(
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check_rounded,
      label: 'Review',
      subtitle: 'Confirm details',
    ),
  ];

  @override
  void initState() {
    super.initState();
    schemeId = stringOrNull(widget.schemeId);
    initialAmount = widget.initialAmount;

    _headerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _headerFade = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOut,
    );
    _headerAnimController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupFlow();
    });
  }

  void _setupFlow() {
    if (!mounted) return;

    final initializer = SchemeJoiningInitializer(
      ref: ref,
      initialAmount: initialAmount,
    );
    initializer.initialize();

    final navigationHelper = PageNavigationHelper(
      pageController: _pageController,
      onNextPage: () {
        if (mounted) ref.read(schemeJoiningServiceProvider).nextPage();
      },
      onPreviousPage: () {
        if (mounted) ref.read(schemeJoiningServiceProvider).previousPage();
      },
    );

    final validationHelper = SchemeJoiningValidationHelper(
      step1FormKey: _step1FormKey,
      step2FormKey: _step2FormKey,
      step3FormKey: _step3FormKey,
    );

    _flowCoordinator = SchemeJoiningFlowCoordinator(
      ref: ref,
      navigationHelper: navigationHelper,
      validationHelper: validationHelper,
      schemeId: schemeId!,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(schemeJoiningControllerProvider);
    final formState = ref.watch(schemeJoiningFormProvider);
    final currentPage = formState.currentPage;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        body: Column(
          children: [
            // ── Custom App Header with stepper ──
            _SchemeJoiningHeader(
              currentPage: currentPage,
              fadeAnimation: _headerFade,
              stepMeta: _stepMeta,
              onBack: () => Navigator.of(context).maybePop(),
            ),

            // ── Page Content ──
            Expanded(child: _buildPageView(formState: formState)),

            // ── Bottom Navigation ──
            SchemeJoiningNavigationButtons(
              currentPage: currentPage,
              isLoading: isLoading,
              onBack: _handleBack,
              onNext: _handleNext,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView({required dynamic formState}) {
    final controllers = ref.watch(formControllersProvider);

    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Step1BranchSelection(
          schemeId: schemeId!,
          selectedNominee: formState.selectedNominee,
          selectedBranch: formState.selectedBranch,
          onNomineeChanged: (value) {
            ref.read(schemeJoiningFormProvider.notifier).setNominee(value);
          },
          onBranchChanged: (value) {
            ref.read(schemeJoiningFormProvider.notifier).setBranch(value);
          },
          formKey: _step1FormKey,
        ),
        Step2BillingAddress(
          addressLine1Controller: controllers.addressLine1Controller,
          addressLine2Controller: controllers.addressLine2Controller,
          cityController: controllers.cityController,
          stateController: controllers.stateController,
          postalCodeController: controllers.postalCodeController,
          countryController: controllers.countryController,
          formKey: _step2FormKey,
        ),
        Step3AmountSelection(
          installmentController: controllers.installmentController,
          formKey: _step3FormKey,
          schemeId: schemeId!,
        ),
        Step4ReviewConfirmation(schemeId: schemeId!),
      ],
    );
  }

  void _handleBack() {
    if (mounted) _flowCoordinator.handleBack();
  }

  void _handleNext() {
    if (mounted) {
      final currentPage = ref.read(schemeJoiningFormProvider).currentPage;
      _flowCoordinator.handleNext(currentPage, context);
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Header + Stepper (self-contained widget)
// ─────────────────────────────────────────────────────────────

class _StepMeta {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String subtitle;

  const _StepMeta({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.subtitle,
  });
}

class _SchemeJoiningHeader extends StatelessWidget {
  final int currentPage;
  final Animation<double> fadeAnimation;
  final List<_StepMeta> stepMeta;
  final VoidCallback onBack;

  const _SchemeJoiningHeader({
    required this.currentPage,
    required this.fadeAnimation,
    required this.stepMeta,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final activeMeta = stepMeta[currentPage];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Palette.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -w * 0.08,
            top: topPadding - 10,
            child: Container(
              width: w * 0.38,
              height: w * 0.38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: w * 0.08,
            bottom: -h * 0.04,
            child: Container(
              width: w * 0.22,
              height: w * 0.22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPadding),

              // ── Top bar: back button + title ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(context, 13),
                  vertical: SizeConfig.h(context, 21),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: SizeConfig.w(context, 24),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        padding: const EdgeInsets.all(13),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(context, 11)),
                    Expanded(
                      child: FadeTransition(
                        opacity: fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Join Scheme',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w * 0.045,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            Text(
                              activeMeta.subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: w * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Step counter badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${currentPage + 1} / ${stepMeta.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.032,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 8)),

              // ── Custom Stepper ──
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(context, 16),
                ),
                child: _CustomStepper(
                  currentPage: currentPage,
                  stepMeta: stepMeta,
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 16)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Custom Stepper Widget
// ─────────────────────────────────────────────────────────────

class _CustomStepper extends StatelessWidget {
  final int currentPage;
  final List<_StepMeta> stepMeta;

  const _CustomStepper({required this.currentPage, required this.stepMeta});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      children: List.generate(stepMeta.length * 2 - 1, (index) {
        // Connector line
        if (index.isOdd) {
          final stepIndex = index ~/ 2;
          final isCompleted = currentPage > stepIndex;
          return Expanded(child: _StepConnector(isCompleted: isCompleted));
        }

        // Step node
        final stepIndex = index ~/ 2;
        final isDone = currentPage > stepIndex;
        final isActive = currentPage == stepIndex;
        final meta = stepMeta[stepIndex];

        return _StepNode(
          stepIndex: stepIndex,
          isDone: isDone,
          isActive: isActive,
          meta: meta,
          w: w,
        );
      }),
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      height: 2,
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
        color: isCompleted
            ? Colors.white.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.2),
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  final int stepIndex;
  final bool isDone;
  final bool isActive;
  final _StepMeta meta;
  final double w;

  const _StepNode({
    required this.stepIndex,
    required this.isDone,
    required this.isActive,
    required this.meta,
    required this.w,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isActive ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: isActive ? 44 : 36,
            height: isActive ? 44 : 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? Colors.white
                  : isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: isDone
                  ? Icon(
                      Icons.check_rounded,
                      color: Palette.primaryColor,
                      size: 18,
                    )
                  : Icon(
                      isActive ? meta.activeIcon : meta.icon,
                      color: isActive
                          ? Palette.primaryColor
                          : Colors.white.withValues(alpha: 0.5),
                      size: isActive ? 20 : 17,
                    ),
            ),
          ),
          const SizedBox(height: 5),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: isActive ? w * 0.029 : w * 0.026,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive
                  ? Colors.white
                  : isDone
                  ? Colors.white.withValues(alpha: 0.75)
                  : Colors.white.withValues(alpha: 0.4),
            ),
            child: Text(meta.label),
          ),
        ],
      ),
    );
  }
}
