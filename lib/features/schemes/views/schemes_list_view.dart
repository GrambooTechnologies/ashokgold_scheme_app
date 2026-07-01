import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/scheme_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/scheme_detail_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/widgets/scheme_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/view/contact_support_button.dart';

class SchemesListView extends ConsumerWidget {
  static const String routeName = '/schemes';

  const SchemesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schemesAsync = ref.watch(schemesListProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: SizeConfig.h(context, 36),
      ),

      // ================= BODY =================
      body: schemesAsync.when(
        data: (schemes) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(schemesListProvider.notifier).refreshList();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.w(context, 24)),
                    child: Text(
                      'Explore Our Scheme Plans',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(context, 3)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.w(context, 24),
                      right: SizeConfig.w(context, 36),
                    ),
                    child: Text(
                      "Save monthly with ease and confidence, Explore our gold and diamond schemes to find your perfect plan.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: SizeConfig.w(context, 12),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(context, 13)),
                  // ================= LIST =================
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: SizeConfig.h(context, 8)),
                    itemCount: schemes.length,
                    itemBuilder: (context, index) {
                      final scheme = schemes[index];

                      return SchemeCardWidget(
                        scheme: scheme,
                        onTap: () {
                          context.push(
                            SchemeDetailView.routePath(scheme.schemeId),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: SizeConfig.h(context, 13)),

                  ContactSupportButton(),
                  SizedBox(height: SizeConfig.w(context, 31)),
                ],
              ),
            ),
          );
        },
        loading: () => const Loader(),
        error: (error, stack) => ErrorRetryWidget(
          message: 'Failed to load schemes',
          onRetry: () => ref.invalidate(schemesListProvider),
        ),
      ),
    );
  }

  Widget _stepCard({
    required IconData icon,
    required String text,
    required BuildContext context,
  }) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.45,
      height: size.height * 0.17,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.02,
        horizontal: size.width * 0.04,
      ),
      decoration: BoxDecoration(
        // color: const Color(0xFFFFFBEF),
        borderRadius: BorderRadius.circular(size.width * 0.04),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: size.width * 0.07, // responsive icon
            color: Palette.primaryColor,
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: size.width * 0.03, height: 1.4),
          ),
        ],
      ),
    );
  }
}
