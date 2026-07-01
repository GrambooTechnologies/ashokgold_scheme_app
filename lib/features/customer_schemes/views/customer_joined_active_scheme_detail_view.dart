import 'package:ashokgold_scheme_app/core/constants/scheme_type_constants.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_floating_button.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/asset_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/providers/customer_joined_active_scheme_detail_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/installment_history_view.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/installment_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/dottedDivider.dart';
import '../../../core/utilities/scale_size_utils.dart';
import '../../common/providers/metal_rate_provider.dart';
import '../../common/view/emi_progress_card.dart';

class CustomerJoinedSchemeDetailView extends ConsumerStatefulWidget {
  static const String routeName = '/customer-joined-scheme-detail';

  static String routePath(String joinId) {
    return '/customer-joined-scheme-detail/$joinId';
  }

  final String joinId;

  const CustomerJoinedSchemeDetailView({super.key, required this.joinId});

  @override
  ConsumerState<CustomerJoinedSchemeDetailView> createState() =>
      _CustomerJoinedSchemeDetailViewState();
}

class _CustomerJoinedSchemeDetailViewState
    extends ConsumerState<CustomerJoinedSchemeDetailView> {
  String? joinId;
  bool _isNomineeExpanded = false;
  final bool _isLastPaymentExpanded = false;

  @override
  void initState() {
    super.initState();
    joinId = stringOrNull(widget.joinId);
  }

  @override
  Widget build(BuildContext context) {
    final schemeDetailAsync = ref.watch(
      customerJoinedActiveSchemeDetailProvider(joinId!),
    );
    final metalRateAsync = ref.watch(latestMetalRateProvider);

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: true,
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
      ),
      body: schemeDetailAsync.when(
        data: (schemeDetail) {
          final bool isCompleted = !schemeDetail.isActive;
          final Color schemeColor = isCompleted
              ? Colors.green.shade700
              : Palette.primaryColor;
          final Color inactiveEmiColor = isCompleted
              ? Colors.green.shade100
              : Palette.primaryColor.withOpacity(0.15);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Join Number and Scheme Code in Column
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              schemeDetail.scheme.schemeName,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: SizeConfig.w(context, 20),
                                    fontWeight: FontWeight.w800,
                                    color: Palette.blackColor,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: SizeConfig.w(context, 12)),
                            Container(
                              height: SizeConfig.h(context, 25),
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.03,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(w * 0.016),
                              ),
                              child: Center(
                                child: Text(
                                  schemeDetail.scheme.schemeCode,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: SizeConfig.w(context, 11),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade700,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "You're enrolled in ${schemeDetail.scheme.schemeName}. Redeem in month 11 with 0% making charge and 3% GST.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: SizeConfig.w(context, 12),
                          fontWeight: FontWeight.w300,
                          color: Palette.blackColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: h * 0.013),
                      Text(
                        'Join No  #${schemeDetail.joinNo}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: SizeConfig.w(context, 15),
                          fontWeight: FontWeight.w600,
                          color: Palette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Financial Details Section
                SizedBox(height: h * 0.01),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      FieldValueRow(
                        field: 'Joined Date',
                        value:
                            FormatDateTime.yyyymmddToDDMMMYYYY(
                              schemeDetail.joinDate,
                            ) ??
                            'N/A',
                      ),
                      FieldValueRow(
                        field: 'End Date',
                        value: schemeDetail.matureDate != null
                            ? FormatDateTime.yyyymmddToDDMMMYYYY(
                                schemeDetail.matureDate!,
                              )!
                            : 'N/A',
                      ),
                      if (schemeDetail.nextDueDate != null)
                        FieldValueRow(
                          field: 'Next Due Date',
                          value: schemeDetail.nextDueDate != null
                              ? FormatDateTime.yyyymmddToDDMMMYYYY(
                                  schemeDetail.nextDueDate!,
                                )!
                              : 'N/A',
                        ),
                      FieldValueRow(
                        field: 'Remaining EMA',
                        value:
                            '${schemeDetail.progress.numberOfInstallmentsPaid} / ${schemeDetail.scheme.totalInstallments} Months',
                      ),
                      if (int.tryParse(
                            schemeDetail.scheme.schemeType.schemeTypeId,
                          ) ==
                          SchemeType.fixedId)
                        FieldValueRow(
                          field: 'Total Scheme Amount',
                          value: formatCurrency(
                            schemeDetail.scheme.totalSchemeAmount,
                          ),
                        ),
                      FieldValueRow(
                        showDivider: false,
                        field: 'Total Paid Amount',
                        value: formatCurrency(schemeDetail.progress.totalPaid),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.01),

                Container(
                  width: w,
                  height: h * .11,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: h * 0.015),
                        Text(
                          "Accumulated Value",
                          style: TextStyle(
                            fontSize: w * 0.034,
                            height: 1,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            color: Palette.primaryColor,
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _countSection(
                              context,
                              alignment: CrossAxisAlignment.start,
                              field: "Paid Amount",
                              label: formatCurrency(
                                schemeDetail.progress.totalPaid,
                              ),
                            ),
                            _countSection(
                              context,
                              alignment: CrossAxisAlignment.end,
                              field: "Gold Weight",
                              label:
                                  "${schemeDetail.progress.totalAccumulatedGoldWeight.toStringAsFixed(8)} g",
                            ),
                          ],
                        ),
                        SizedBox(height: h * 0.007),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: h * 0.024),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                  child: EmiProgressCard(
                    totalMonths: schemeDetail.scheme.totalInstallments,
                    completedMonths:
                        schemeDetail.progress.numberOfInstallmentsPaid,
                    activeColor: schemeColor,
                    inactiveColor: inactiveEmiColor,
                  ),
                ),

                SizedBox(height: h * 0.003),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scheme Progress',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: SizeConfig.w(context, 14),
                          fontWeight: FontWeight.w700,
                          color: Palette.blackColor,
                        ),
                      ),
                      Text(
                        '${schemeDetail.progress.numberOfInstallmentsPaid} / ${schemeDetail.scheme.totalInstallments} ',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: SizeConfig.w(context, 13),
                          fontWeight: FontWeight.w700,
                          color: Palette.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nominee Information (if exists)
                SizedBox(height: h * 0.02),
                if (schemeDetail.nominee != null) ...[
                  _buildExpandableSection(
                    context: context,
                    title: 'Nominee Information',
                    isExpanded: _isNomineeExpanded,
                    onTap: () {
                      setState(() {
                        _isNomineeExpanded = !_isNomineeExpanded;
                      });
                    },
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.025),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            FieldValueRow(
                              field: 'Nominee Name',
                              value: schemeDetail.nominee!.nomineeName,
                            ),
                            FieldValueRow(
                              field: 'Relationship',
                              value: schemeDetail.nominee!.nomineeRelationName,
                            ),
                            FieldValueRow(
                              field: 'Mobile',
                              value: schemeDetail.nominee!.nomineeMobile ?? '—',
                              showDivider: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: h * 0.01),

                // Pay Next Installment Button
                if (schemeDetail.isActive &&
                    schemeDetail.progress.percentComplete < 100)
                  Center(
                    child: _buildPayInstallmentButton(
                      context: context,
                      joinId: schemeDetail.joinId,
                      schemeName: schemeDetail.scheme.schemeName,
                      installmentAmount:
                          schemeDetail.scheme.totalSchemeAmount /
                          schemeDetail.scheme.totalInstallments,
                    ),
                  ),

                SizedBox(height: h * 0.015),

                // Payment History Button
                Center(
                  child: _buildPaymentHistoryButton(
                    context: context,
                    joinId: schemeDetail.joinId,
                  ),
                ),

                SizedBox(height: h * 0.05),
                Container(
                  width: w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetConstants.background),
                      fit: BoxFit.cover,
                      opacity: 0.8,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.h(context, 10)),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.h(context, 18)),
                        Text(
                          "${schemeDetail.scheme.schemeName} Card",
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: SizeConfig.w(context, 17),
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.h(context, 17),
                            bottom: SizeConfig.h(context, 25),
                            left: SizeConfig.w(context, 10),
                            right: SizeConfig.w(context, 10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SizeConfig.w(context, 10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AssetConstants.schemeCard),
                                  fit: BoxFit.cover,
                                  opacity: 0.8,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: SizeConfig.h(context, 150),
                                  bottom: SizeConfig.h(context, 25),
                                  left: SizeConfig.w(context, 15),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "Number",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "Join No",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ":",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          ":",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          ":",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          schemeDetail.customer.customerName,
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "+91 ${schemeDetail.customer.customerPhone}",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          schemeDetail.joinNo,
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 12),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Urbanist',
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: h * 0.05),
              ],
            ),
          );
        },
        loading: () {
          return const Loader();
        },
        error: (error, stackTrace) {
          return ErrorRetryWidget(
            message: error.toString(),
            onRetry: () {
              ref.invalidate(customerJoinedActiveSchemeDetailProvider(joinId!));
            },
          );
        },
      ),
    );
  }

  Widget _countSection(
    BuildContext context, {
    required String field,
    required String label,
    CrossAxisAlignment alignment = CrossAxisAlignment.start,
    TextAlign textAlign = TextAlign.start,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          field,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 13),
            height: 1,
            fontFamily: 'Urbanist',
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: w * 0.005),
        Text(
          label,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 16),
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPayInstallmentButton({
    required BuildContext context,
    required String joinId,
    required String schemeName,
    required double installmentAmount,
  }) {
    return CustomFloatingButton(
      text: "Pay Next Installment",
      onPressed: () => _handlePayInstallment(
        context: context,
        joinId: joinId,
        schemeName: schemeName,
        installmentAmount: installmentAmount,
      ),
    );
  }

  void _handlePayInstallment({
    required BuildContext context,
    required String joinId,
    required String schemeName,
    required double installmentAmount,
  }) {
    context.push(
      InstallmentPaymentPage.routeName,
      extra: {
        'joinId': joinId,
        'schemeName': schemeName,
        'installmentAmount': installmentAmount.toStringAsFixed(2),
      },
    );
  }

  Widget _buildPaymentHistoryButton({
    required BuildContext context,
    required String joinId,
  }) {
    return CustomFloatingButton(
      backgroundColor: Colors.white,
      textColor: Palette.primaryColor,
      text: "Installment History",
      borderColor: Palette.primaryColor,
      borderWidth: 0.5,
      onPressed: () {
        context.push(InstallmentHistoryView.routePath(joinId));
      },
    );
  }

  Widget _buildExpandableSection({
    required BuildContext context,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
    Color? accentColor,
  }) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final Color color = accentColor ?? Palette.primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
      child: Container(
        margin: EdgeInsets.only(bottom: h * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(w * 0.02),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            /// HEADER
            InkWell(
              borderRadius: BorderRadius.circular(w * 0.03),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: h * 0.016,
                ),
                child: Row(
                  children: [
                    /// TITLE
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                      ),
                    ),

                    /// ARROW
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: color,
                        size: w * 0.065,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// BODY
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.fromLTRB(w * 0.03, 0, w * 0.03, h * 0.015),
                child: Column(children: children),
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
