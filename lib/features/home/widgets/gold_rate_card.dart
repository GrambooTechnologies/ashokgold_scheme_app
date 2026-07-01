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

    return Positioned(
      bottom: 0,
      left: w * 0.06,
      right: w * 0.06,
      child: GestureDetector(
        onTap: () {
          // Navigate to gold rate screen
        },
        child: Container(
          width: w * 0.86,
          height: h * 0.1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF8F2E5),
                Color(0xFFF6EFDF),
                Color(0xFFF4EACF),
              ],
            ),
            borderRadius: BorderRadius.circular(w * 0.05),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: -1,
                offset: Offset(-1, 03),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: w * 0.05),
            child: metalRateAsync.when(
              data: (metalRate) {
                final formattedDate = FormatDateTime.dateTimeToDDMMYYYY(
                  DateTime.parse(metalRate.entryDate),
                );
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: h * 0.016),
                      child: SizedBox(
                        width: w * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(),
                            Text(
                              '22k Gold Rate',
                              style: TextStyle(
                                fontSize: w * .03,
                                fontFamily: 'Urbanist',
                                color: Palette.blackColor,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    '₹${(metalRate.rates.metalRate * 8).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: w * .045,
                                  fontWeight: FontWeight.w700,
                                  color: Palette.primaryColor,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' (8 gram)',
                                    style: TextStyle(
                                      fontSize: w * .031,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Urbanist',
                                      color: Palette.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Updated on $formattedDate',
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              style: TextStyle(
                                height: 1,
                                fontSize: w * .023,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Urbanist',
                                color: Palette.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Image.asset(AssetConstants.goldBar, height: h * 0.08),
                  ],
                );
              },
              loading: () => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: w * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: w * 0.3,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Palette.whiteColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: w * 0.4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Palette.whiteColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: w * 0.2,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Palette.whiteColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: w * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '22k Gold Rate',
                          style: TextStyle(
                            fontSize: w * .03,
                            fontFamily: 'Urbanist',
                            color: Palette.blackColor,
                          ),
                        ),
                        Text(
                          'Unable to load',
                          style: TextStyle(
                            fontSize: w * .036,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Urbanist',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.invalidate(latestMetalRateProvider);
                    },
                    icon: Icon(
                      Icons.refresh,
                      size: w * 0.05,
                      color: Palette.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
