import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/asset_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/providers/customer_closed_scheme_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/dottedDivider.dart';
import '../../../core/utilities/scale_size_utils.dart';

class CustomerClosedSchemeDetailView extends ConsumerStatefulWidget {
  static const String routeName = '/customer-closed-sche me-detail';

  static String routePath(String closingId) {
    return '/customer-closed-scheme-detail/$closingId';
  }

  final String closingId;

  const CustomerClosedSchemeDetailView({super.key, required this.closingId});

  @override
  ConsumerState<CustomerClosedSchemeDetailView> createState() =>
      _CustomerClosedSchemeDetailViewState();
}

class _CustomerClosedSchemeDetailViewState
    extends ConsumerState<CustomerClosedSchemeDetailView> {
  String? closingId;
  bool _isClosingDetailsExpanded = false;
  bool _isPaymentDetailsExpanded = false;

  @override
  void initState() {
    super.initState();
    closingId = stringOrNull(widget.closingId);
  }

  @override
  Widget build(BuildContext context) {
    final schemeDetailAsync = ref.watch(
      customerClosedSchemeDetailProvider(closingId!),
    );

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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Closing Number and Scheme Code in Column
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.03,
                          vertical: h * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(w * 0.016),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: w * 0.04,
                            ),
                            SizedBox(width: w * 0.015),
                            Text(
                              'SCHEME CLOSED',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: SizeConfig.w(context, 11),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.015),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              schemeDetail.scheme.schemeName,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontSize: SizeConfig.w(context, 20),
                                    fontWeight: FontWeight.w700,
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
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(w * 0.016),
                              ),
                              child: Center(
                                child: Text(
                                  schemeDetail.scheme.schemeCode,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontSize: SizeConfig.w(context, 11),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade700,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        "This scheme has been successfully closed and settled.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: SizeConfig.w(context, 12),
                          fontWeight: FontWeight.w300,
                          color: Palette.blackColor,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: h * 0.013),
                      Text(
                        'Closing No  #${schemeDetail.closingNo}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: SizeConfig.w(context, 15),
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade900,
                        ),
                      ),
                      SizedBox(height: h * 0.005),
                      Text(
                        'Join No  #${schemeDetail.scheme.joinNo}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: SizeConfig.w(context, 13),
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Financial Details Section
                SizedBox(height: h * 0.02),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      FieldValueRow(
                        field: 'Closing Date',
                        value:
                            FormatDateTime.yyyymmddToDDMMMYYYY(
                              schemeDetail.closingDate,
                            ) ??
                            'N/A',
                      ),
                      FieldValueRow(
                        field: 'Join Date',
                        value:
                            FormatDateTime.yyyymmddToDDMMMYYYY(
                              schemeDetail.scheme.joinDate,
                            ) ??
                            'N/A',
                      ),
                      FieldValueRow(
                        field: 'Mature Date',
                        value:
                            FormatDateTime.yyyymmddToDDMMMYYYY(
                              schemeDetail.scheme.matureDate,
                            ) ??
                            'N/A',
                      ),
                      if (schemeDetail.closingDetails.closingType != null)
                        FieldValueRow(
                          field: 'Closing Type',
                          value: schemeDetail.closingDetails.closingType!,
                        ),
                      FieldValueRow(
                        showDivider: false,
                        field: 'Scheme Type',
                        value:
                            '${schemeDetail.scheme.schemeType.schemeTypeName} - ${schemeDetail.scheme.schemeGroup.schemeGroupName}',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * 0.01),

                // Financial Summary Section
                Container(
                  width: w,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.05,
                      vertical: h * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Financial Summary",
                          style: TextStyle(
                            fontSize: w * 0.034,
                            height: 1,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            color: Palette.primaryColor,
                          ),
                        ),
                        SizedBox(height: h * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _countSection(
                              context,
                              alignment: CrossAxisAlignment.start,
                              field: "Total Deposit",
                              label: formatCurrency(
                                schemeDetail
                                        .paymentDetails
                                        .totalDepositAmount ??
                                    0,
                              ),
                            ),
                            _countSection(
                              context,
                              alignment: CrossAxisAlignment.end,
                              field: "Closing Amount",
                              label: formatCurrency(
                                schemeDetail.closingDetails.closingAmount ?? 0,
                              ),
                            ),
                          ],
                        ),
                        if (schemeDetail.closingDetails.benefitAmount != null)
                          SizedBox(height: h * 0.015),
                        if (schemeDetail.closingDetails.benefitAmount != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _countSection(
                                context,
                                alignment: CrossAxisAlignment.start,
                                field: "Paid Amount",
                                label: formatCurrency(
                                  schemeDetail.closingDetails.paidAmount ?? 0,
                                ),
                              ),
                              _countSection(
                                context,
                                alignment: CrossAxisAlignment.end,
                                field: "Benefit Amount",
                                label: formatCurrency(
                                  schemeDetail.closingDetails.benefitAmount ??
                                      0,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: h * 0.01),

                // Closing Details Expandable Section
                _buildExpandableSection(
                  context: context,
                  title: 'Closing Details',
                  isExpanded: _isClosingDetailsExpanded,
                  onTap: () {
                    setState(() {
                      _isClosingDetailsExpanded = !_isClosingDetailsExpanded;
                    });
                  },
                  accentColor: Colors.green.shade900,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(w * 0.025),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          if (schemeDetail.closingDetails.goldRate != null)
                            FieldValueRow(
                              field: 'Gold Rate',
                              value:
                                  '₹${schemeDetail.closingDetails.goldRate!.toStringAsFixed(2)}/g',
                            ),
                          if (schemeDetail.closingDetails.paidWt != null)
                            FieldValueRow(
                              field: 'Paid Weight',
                              value:
                                  '${schemeDetail.closingDetails.paidWt!.toStringAsFixed(3)} g',
                            ),
                          if (schemeDetail.closingDetails.benefitWt != null)
                            FieldValueRow(
                              field: 'Benefit Weight',
                              value:
                                  '${schemeDetail.closingDetails.benefitWt!.toStringAsFixed(3)} g',
                            ),
                          if (schemeDetail.closingDetails.closingWt != null)
                            FieldValueRow(
                              field: 'Closing Weight',
                              value:
                                  '${schemeDetail.closingDetails.closingWt!.toStringAsFixed(3)} g',
                              showDivider: false,
                            ),
                          if (schemeDetail.closingDetails.closingWt == null &&
                              schemeDetail.closingDetails.benefitWt == null &&
                              schemeDetail.closingDetails.paidWt == null &&
                              schemeDetail.closingDetails.goldRate == null)
                            Padding(
                              padding: EdgeInsets.all(w * 0.04),
                              child: Text(
                                'No additional closing details available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: w * 0.035,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Payment Details Expandable Section
                _buildExpandableSection(
                  context: context,
                  title: 'Payment Details',
                  isExpanded: _isPaymentDetailsExpanded,
                  onTap: () {
                    setState(() {
                      _isPaymentDetailsExpanded = !_isPaymentDetailsExpanded;
                    });
                  },
                  accentColor: Colors.green.shade900,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(w * 0.025),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          if (schemeDetail.paymentDetails.totalGst != null)
                            FieldValueRow(
                              field: 'Total GST',
                              value: formatCurrency(
                                schemeDetail.paymentDetails.totalGst!,
                              ),
                            ),
                          if (schemeDetail.paymentDetails.cgst != null)
                            FieldValueRow(
                              field: 'CGST',
                              value: formatCurrency(
                                schemeDetail.paymentDetails.cgst!,
                              ),
                            ),
                          if (schemeDetail.paymentDetails.sgst != null)
                            FieldValueRow(
                              field: 'SGST',
                              value: formatCurrency(
                                schemeDetail.paymentDetails.sgst!,
                              ),
                            ),
                          if (schemeDetail.paymentDetails.igst != null)
                            FieldValueRow(
                              field: 'IGST',
                              value: formatCurrency(
                                schemeDetail.paymentDetails.igst!,
                              ),
                              showDivider: false,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Customer Information Section
                SizedBox(height: h * 0.01),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      FieldValueRow(
                        field: 'Customer Name',
                        value: schemeDetail.customer.customerName,
                      ),
                      FieldValueRow(
                        field: 'Phone',
                        value: schemeDetail.customer.customerPhone,
                        showDivider: false,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: h * 0.02),

                // Membership Card Section
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
                          "${schemeDetail.scheme.schemeName} Closing Certificate",
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
                                          "Scheme",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Urbanist",
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "Closing No",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Urbanist",
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          "Closing Date",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Urbanist",
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
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Urbanist",
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          ":",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Urbanist",
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          ":",
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Urbanist",
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
                                        SizedBox(
                                          width: SizeConfig.w(context, 180),
                                          child: Text(
                                            schemeDetail.scheme.schemeName,
                                            style: TextStyle(
                                              fontSize: SizeConfig.w(
                                                context,
                                                11,
                                              ),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Urbanist",
                                              color: Palette.blackColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          schemeDetail.closingNo,
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Urbanist",
                                            color: Palette.blackColor,
                                          ),
                                        ),
                                        Text(
                                          FormatDateTime.yyyymmddToDDMMMYYYY(
                                                schemeDetail.closingDate,
                                              ) ??
                                              'N/A',
                                          style: TextStyle(
                                            fontSize: SizeConfig.w(context, 11),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Urbanist",
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
              ref.invalidate(customerClosedSchemeDetailProvider(closingId!));
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
                          fontWeight: FontWeight.w700,
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
