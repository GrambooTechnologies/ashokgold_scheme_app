import 'package:ashokgold_scheme_app/core/custom_widgets/customSearch_common.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/login_required_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/custom_widgets/error_retry_widget.dart';
import '../../../core/utilities/loader.dart';
import '../../../core/utilities/scale_size_utils.dart';
import '../providers/customer_active_schemes_provider.dart';
import '../widgets/completed_schemes_tab.dart';
import '../widgets/active_scheme_card_widget.dart';

final selectedTabProvider = StateProvider<String>((ref) => 'All');

class CustomerSchemesView extends ConsumerWidget {
  CustomerSchemesView({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(customerProvider);
    final selectedTab = ref.watch(selectedTabProvider);

    // Check if user is authenticated
    if (customer == null) {
      return const LoginRequiredWidget(
        title: 'Your Enrolled Schemes',
        message:
            'Please login to view your joined schemes and track your progress.',
        icon: Icons.lock_outline,
      );
    }

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final joinedSchemesAsync = ref.watch(customerJoinedActiveSchemesProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: SizeConfig.h(context, 36),
      ),
      body: joinedSchemesAsync.when(
        loading: () {
          return const Loader();
        },
        error: (error, stack) {
          return ErrorRetryWidget(
            message: 'Error loading schemes: ${error.toString()}',
            onRetry: () {
              ref.invalidate(customerJoinedActiveSchemesProvider);
            },
          );
        },
        data: (schemes) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (schemes.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.w(context, 24)),
                    child: Text(
                      'No active schemes',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.w(context, 22)),
                    child: Text(
                      'Your Enrolled Schemes',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 20),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                SizedBox(height: SizeConfig.h(context, 3)),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.w(context, 22),
                    right: SizeConfig.w(context, 24),
                  ),
                  child: Text(
                    "Track all your joined anaswara schemes in one place. View status, payment progress, and benefits at a glance",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      height: 1.2,
                      fontSize: SizeConfig.w(context, 12),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.h(context, 18)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(context, 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: SizeConfig.h(context, 50),
                        width: SizeConfig.w(context, 320),
                        child: CustomSearchField(
                          controller: searchController,
                          labelText: "Search here...",
                        ),
                      ),
                      Container(
                        height: SizeConfig.h(context, 50),
                        width: SizeConfig.h(context, 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.w(context, 13),
                          ),
                          color: Palette.primaryColor,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: SizeConfig.w(context, 24),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.h(context, 20)),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: schemes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        w * 0.03,
                        0,
                        w * 0.03,
                        h * 0.015,
                      ),
                      child: ActiveSchemeCardWidget(
                        scheme: schemes[index],
                        accentColor: Colors.amber,
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    context.push(CompletedSchemesTab.routeName);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.w(context, 15),
                    ),
                    child: Container(
                      width: w,
                      height: SizeConfig.h(context, 60),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Palette.shadowColor.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Palette.cardBackgroundColor,
                          width: 0.02,
                        ),
                        borderRadius: BorderRadius.circular(
                          SizeConfig.w(context, 15),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(context, 20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Completed Schemes ',
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontSize: SizeConfig.w(context, 15),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Palette.primaryColor,
                              size: SizeConfig.w(context, 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.01),
                if (schemes.isNotEmpty)
                  Center(
                    child: Text(
                      "That's all you got!",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: w * .03,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                SizedBox(height: h * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }
}
