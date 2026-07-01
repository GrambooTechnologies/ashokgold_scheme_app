import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_closed_scheme_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_closed_scheme_detail_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utilities/asset_constants.dart';
import '../../../core/utilities/formatting/formatDate/format_dateTime.dart';
import '../../../core/utilities/scale_size_utils.dart';

class ClosedSchemeCardWidget extends StatelessWidget {
  final CustomerClosedSchemeResponse scheme;
  final Color accentColor;

  const ClosedSchemeCardWidget({
    super.key,
    required this.scheme,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // Navigate to closed scheme detail view
        context.push(
          CustomerClosedSchemeDetailView.routePath(scheme.closingId),
        );
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
                          CupertinoIcons.checkmark_seal_fill,
                          size: SizeConfig.w(context, 19),
                          color: Colors.green.shade900,
                        ),
                        SizedBox(width: 5),
                        Text(
                          scheme.closingNo,
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
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Closed',
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
              // Scheme Name
              Text(
                scheme.scheme.schemeName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                  fontSize: SizeConfig.w(context, 15),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 12)),
              // Join Number
              Text(
                'Join No: ${scheme.scheme.joinNo}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: SizeConfig.w(context, 13),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 20)),
              // Total Deposit and Closing Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Deposit',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: SizeConfig.w(context, 11),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 1)),
                      Text(
                        '₹${scheme.progress.totalPaid}',
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
                        'Closing Amount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: SizeConfig.w(context, 11),
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 1)),
                      Text(
                        '₹${scheme.closingDetails.closingAmount?.toStringAsFixed(0) ?? '0'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.w(context, 14),
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(context, 16)),
              // Closing Type
              if (scheme.closingDetails.closingType != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(context, 12),
                    vertical: SizeConfig.h(context, 6),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.arrow_right_circle_fill,
                        size: SizeConfig.w(context, 14),
                        color: Colors.green.shade700,
                      ),
                      SizedBox(width: SizeConfig.w(context, 6)),
                      Text(
                        'Type: ${scheme.closingDetails.closingType}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green.shade900,
                          fontSize: SizeConfig.w(context, 12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: SizeConfig.h(context, 16)),
              // Closing Date
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Closing Date',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.w(context, 11),
                              ),
                        ),
                        Text(
                          FormatDateTime.yyyymmddToDDMMMYYYY(
                                scheme.closingDate,
                              ) ??
                              'N/A',
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
                          'Join Date',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontSize: SizeConfig.w(context, 11),
                              ),
                        ),
                        Text(
                          FormatDateTime.yyyymmddToDDMMMYYYY(
                                scheme.scheme.joinDate,
                              ) ??
                              'N/A',
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
