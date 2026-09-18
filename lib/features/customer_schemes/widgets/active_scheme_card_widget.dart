import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_joined_active_scheme_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_joined_active_scheme_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utilities/asset_constants.dart';
import '../../../core/utilities/formatting/formatDate/format_dateTime.dart';
import '../../../core/utilities/scale_size_utils.dart';
import '../../common/view/emi_progress_card.dart';

class ActiveSchemeCardWidget extends StatelessWidget {
  final CustomerJoinedActiveSchemeResponse scheme;
  final Color accentColor;

  const ActiveSchemeCardWidget({
    super.key,
    required this.scheme,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final bool isCompleted = !scheme.isActive;

    final Color schemeColor = isCompleted
        ? Colors.green.shade900
        : Palette.primaryColor;

    final Color inactiveEmiColor = isCompleted
        ? Colors.green.shade100
        : Palette.primaryColor.withValues(alpha: 0.15);

    return GestureDetector(
      onTap: () {
        context.push(CustomerJoinedSchemeDetailView.routePath(scheme.joinId));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(AssetConstants.goldBg),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 9,
              spreadRadius: -5,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(SizeConfig.w(context, 15)),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(context, 16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Scheme Name and Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: SizeConfig.w(context, 280),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.creditcard,
                          size: SizeConfig.w(context, 19),
                          color: Palette.primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          scheme.joinNo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Urbanist",
                            fontSize: SizeConfig.w(context, 15),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(context, 8)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(context, 8),
                      vertical: SizeConfig.h(context, 4),
                    ),
                    decoration: BoxDecoration(
                      color: scheme.isActive
                          ? Palette.primaryColor
                          : Colors.green.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isCompleted ? 'Completed' : 'Active',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontSize: SizeConfig.w(context, 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(context, 3)),
              // Join Number
              Text(
                scheme.scheme.schemeName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: SizeConfig.w(context, 15),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 20)),
              // Total Paid and Percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Paid',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: SizeConfig.w(context, 11),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 1)),
                      Text(
                        '₹${scheme.progress.totalPaid.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.w(context, 14),
                          color: Palette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: SizeConfig.w(context, 11),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 1)),
                      Text(
                        '${scheme.progress.numberOfInstallmentsPaid} / ${scheme.scheme.totalInstallments}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.w(context, 14),
                          color: Palette.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              EmiProgressCard(
                totalMonths: scheme.scheme.totalInstallments,
                completedMonths: scheme.progress.numberOfInstallmentsPaid,
                activeColor: schemeColor,
                inactiveColor: inactiveEmiColor,
              ),
              SizedBox(height: SizeConfig.h(context, 20)),
              if (scheme.scheme.convWt == true) ...[
                Row(
                  children: [
                    Icon(
                      Icons.scale_outlined,
                      size: SizeConfig.w(context, 14),
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: SizeConfig.w(context, 6)),
                    Text(
                      'Accumulated Weight: ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: SizeConfig.w(context, 12),
                      ),
                    ),
                    Text(
                      '${scheme.progress.totalAccumulatedGoldWeight.toStringAsFixed(8)} g',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Palette.primaryColor,
                        fontSize: SizeConfig.w(context, 13),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.h(context, 12)),
              ],
              // Last Payment Date and Next Payment Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Payment',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.w(context, 11),
                              ),
                        ),
                        Text(
                          FormatDateTime.yyyymmddToDDMMMYYYY(
                                scheme.lastPayment.paymentDate,
                              ) ??
                              'Not paid',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[800],
                                fontSize: SizeConfig.w(context, 14),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(context, 12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Payment',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.w(context, 11),
                              ),
                        ),
                        Text(
                          FormatDateTime.yyyymmddToDDMMMYYYY(
                                scheme.nextDueDate,
                              ) ??
                              'N/A',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: scheme.nextDueDate != null
                                    ? schemeColor
                                    : Colors.grey[800],
                                fontSize: SizeConfig.w(context, 14),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      ///
      // child: Card(
      //   elevation: 2,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(w * 0.03),
      //   ),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(w * 0.03),
      //       border: Border(left: BorderSide(color: accentColor, width: 4)),
      //     ),
      //     child: Padding(
      //       padding: EdgeInsets.all(SizeConfig.w(context, 16)),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           // Header Row: Scheme Name and Status
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Expanded(
      //                 child: Text(
      //                   scheme.scheme.schemeName,
      //                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      //                         fontWeight: FontWeight.bold,
      //                         fontSize: SizeConfig.w(context, 16),
      //                       ),
      //                   maxLines: 2,
      //                   overflow: TextOverflow.ellipsis,
      //                 ),
      //               ),
      //               SizedBox(width: SizeConfig.w(context, 8)),
      //               Container(
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: SizeConfig.w(context, 8),
      //                   vertical: SizeConfig.h(context, 4),
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color: accentColor.withOpacity(0.2),
      //                   borderRadius: BorderRadius.circular(12),
      //                 ),
      //                 child: Text(
      //                   scheme.isActive ? 'Active' : 'Completed',
      //                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
      //                         color: accentColor,
      //                         fontSize: SizeConfig.w(context, 12),
      //                         fontWeight: FontWeight.w600,
      //                       ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: SizeConfig.h(context, 8)),
      //           // Join Number
      //           Row(
      //             children: [
      //               Icon(
      //                 Icons.confirmation_number_outlined,
      //                 size: SizeConfig.w(context, 14),
      //                 color: Colors.grey[600],
      //               ),
      //               SizedBox(width: SizeConfig.w(context, 6)),
      //               Text(
      //                 'Join No: ${scheme.joinNo}',
      //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
      //                       color: Colors.grey[700],
      //                       fontSize: SizeConfig.w(context, 13),
      //                       fontWeight: FontWeight.w500,
      //                     ),
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: SizeConfig.h(context, 12)),
      //           // Total Paid and Percentage
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     'Total Paid',
      //                     style:
      //                         Theme.of(context).textTheme.bodySmall?.copyWith(
      //                               color: Colors.grey[600],
      //                               fontSize: SizeConfig.w(context, 12),
      //                             ),
      //                   ),
      //                   SizedBox(height: SizeConfig.h(context, 2)),
      //                   Text(
      //                     '₹${scheme.progress.totalPaid.toStringAsFixed(0)}',
      //                     style:
      //                         Theme.of(context).textTheme.bodyMedium?.copyWith(
      //                               fontWeight: FontWeight.bold,
      //                               fontSize: SizeConfig.w(context, 16),
      //                               color: Palette.primaryColor,
      //                             ),
      //                   ),
      //                 ],
      //               ),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.end,
      //                 children: [
      //                   Text(
      //                     'Progress',
      //                     style:
      //                         Theme.of(context).textTheme.bodySmall?.copyWith(
      //                               color: Colors.grey[600],
      //                               fontSize: SizeConfig.w(context, 12),
      //                             ),
      //                   ),
      //                   SizedBox(height: SizeConfig.h(context, 2)),
      //                   Text(
      //                     '${scheme.progress.percentComplete.toStringAsFixed(1)}%',
      //                     style:
      //                         Theme.of(context).textTheme.bodyMedium?.copyWith(
      //                               fontWeight: FontWeight.w600,
      //                               fontSize: SizeConfig.w(context, 14),
      //                               color: accentColor,
      //                             ),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           SizedBox(height: SizeConfig.h(context, 10)),
      //           // Progress Bar
      //           ClipRRect(
      //             borderRadius: BorderRadius.circular(8),
      //             child: LinearProgressIndicator(
      //               value: scheme.progress.percentComplete / 100,
      //               backgroundColor: Colors.grey[200],
      //               valueColor: AlwaysStoppedAnimation<Color>(accentColor),
      //               minHeight: SizeConfig.h(context, 6),
      //             ),
      //           ),
      //           SizedBox(height: SizeConfig.h(context, 12)),
      //           // Last Payment Date and Next Payment Date
      //           Row(
      //             children: [
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       'Last Payment',
      //                       style:
      //                           Theme.of(context).textTheme.bodySmall?.copyWith(
      //                                 color: Colors.grey[600],
      //                                 fontSize: SizeConfig.w(context, 11),
      //                               ),
      //                     ),
      //                     SizedBox(height: SizeConfig.h(context, 2)),
      //                     Text(
      //                       FormatDateTime.yyyymmddToDDMMMYYYY(
      //                               scheme.lastPayment.paymentDate) ??
      //                           'Not paid',
      //                       style:
      //                           Theme.of(context).textTheme.bodySmall?.copyWith(
      //                                 color: Colors.grey[800],
      //                                 fontSize: SizeConfig.w(context, 12),
      //                                 fontWeight: FontWeight.w500,
      //                               ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(width: SizeConfig.w(context, 12)),
      //               Expanded(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       'Next Payment',
      //                       style:
      //                           Theme.of(context).textTheme.bodySmall?.copyWith(
      //                                 color: Colors.grey[600],
      //                                 fontSize: SizeConfig.w(context, 11),
      //                               ),
      //                     ),
      //                     SizedBox(height: SizeConfig.h(context, 2)),
      //                     Text(
      //                       FormatDateTime.yyyymmddToDDMMMYYYY(
      //                               scheme.nextDueDate) ??
      //                           'N/A',
      //                       style:
      //                           Theme.of(context).textTheme.bodySmall?.copyWith(
      //                                 color: scheme.nextDueDate != null
      //                                     ? Palette.primaryColor
      //                                     : Colors.grey[800],
      //                                 fontSize: SizeConfig.w(context, 12),
      //                                 fontWeight: FontWeight.w600,
      //                               ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
