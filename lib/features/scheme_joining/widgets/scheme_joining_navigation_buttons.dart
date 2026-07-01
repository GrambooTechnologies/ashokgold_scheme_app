import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:flutter/material.dart';

class SchemeJoiningNavigationButtons extends StatelessWidget {
  final int currentPage;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const SchemeJoiningNavigationButtons({
    super.key,
    required this.currentPage,
    required this.isLoading,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentPage == 3;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 16),
        vertical: SizeConfig.h(context, 12),
      ),
      decoration: BoxDecoration(
        color: Palette.whiteColor,
        border: Border(
          top: BorderSide(
            color: Palette.shadowColor.withOpacity(0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.shadowColor.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (currentPage > 0) ...[
              SizedBox(
                width: SizeConfig.w(context, 139),
                child: _BackButton(onBack: onBack),
              ),
              SizedBox(width: SizeConfig.w(context, 10)),
            ],
            Expanded(
              flex: currentPage == 0 ? 1 : 1,
              child: _NextButton(
                isLoading: isLoading,
                isLastStep: isLastStep,
                onNext: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onBack;

  const _BackButton({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onBack,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Palette.primaryColor, width: 1.5),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 14)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Palette.primaryColor.withOpacity(0.04),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Palette.primaryColor,
            size: 16,
          ),
          SizedBox(width: SizeConfig.w(context, 6)),
          Text(
            'Back',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Palette.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.w(context, 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isLoading;
  final bool isLastStep;
  final VoidCallback onNext;

  const _NextButton({
    required this.isLoading,
    required this.isLastStep,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: ElevatedButton(
        onPressed: isLoading ? null : onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLastStep
              ? const Color(0xFF0F6E56)
              : Palette.primaryColor,
          foregroundColor: Palette.whiteColor,
          disabledBackgroundColor: Palette.primaryColor.withOpacity(0.5),
          padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 14)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isLoading ? 0 : 2,
          shadowColor: Palette.primaryColor.withOpacity(0.4),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(context, 13),
                      ),
                      child: Text(
                        isLastStep ? 'Proceed to Payment' : 'Continue',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Palette.whiteColor,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.w(context, 15),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(context, 8)),
                    Icon(
                      isLastStep
                          ? Icons.payment_rounded
                          : Icons.arrow_forward_ios_rounded,
                      size: 16,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
