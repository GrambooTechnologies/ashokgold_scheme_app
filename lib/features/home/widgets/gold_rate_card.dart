import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/features/common/providers/metal_rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utilities/asset_constants.dart';

class GoldRateCard extends ConsumerWidget {
  const GoldRateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final metalRateAsync = ref.watch(latestMetalRateProvider);

    return metalRateAsync.when(
      data: (metalRate) {
        final formattedDate = FormatDateTime.dateTimeToDDMMMYYYY(
          DateTime.parse(metalRate.entryDate),
        );
        return Container(
          width: w,
          height: h * 0.052,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF9F4E6),
                Color(0xFFFFFFFF),
                Color(0xFFFDFBF7),
                Color(0xFFF9F4E6),
                Color(0xFFF5EAD2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.only(left: w * 0.04, right: w * 0.075),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(AssetConstants.goldBar, height: h * 0.038),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '22K GOLD RATE',
                        style: TextStyle(
                          fontSize: w * .022,
                          fontFamily: 'Urbanist',
                          color: Palette.blackColor.withOpacity(0.55),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text:
                              '₹${metalRate.rates.metalRate.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: w * .034,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Urbanist',
                            color: Palette.primaryColor,
                            letterSpacing: 0.1,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' /gram',
                              style: TextStyle(
                                fontSize: w * .022,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Urbanist',
                                color: Palette.blackColor.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                'Updated on \n$formattedDate',
                textAlign: TextAlign.right,
                maxLines: 2,
                style: TextStyle(
                  height: 1.25,
                  fontSize: w * .022,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                  color: Palette.blackColor.withOpacity(0.4),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(width: w, height: h * 0.052, color: Colors.grey[300]),
      ),
      error: (error, stack) => Container(
        width: w,
        height: h * 0.052,
        color: Colors.red[50],
        child: Center(
          child: Text(
            'Unable to load gold rate',
            style: TextStyle(
              fontSize: w * 0.026,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
