import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/providers/customer_closed_schemes_provider.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/widgets/closed_scheme_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompletedSchemesTab extends ConsumerWidget {
  static const routeName = '/completed-schemes';
  const CompletedSchemesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final closedSchemesAsync = ref.watch(customerClosedSchemesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Completed Schemes')),
      body: closedSchemesAsync.when(
        loading: () => const Loader(),
        error: (error, stack) => ErrorRetryWidget(
          message: 'Error loading schemes: ${error.toString()}',
          onRetry: () {
            ref.invalidate(customerClosedSchemesProvider);
          },
        ),
        data: (schemes) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: h * 0.02),
                if (schemes.isEmpty)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: h * 0.1),
                      child: Text(
                        "No completed schemes",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: w * .035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                else
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
                        child: ClosedSchemeCardWidget(
                          scheme: schemes[index],
                          accentColor: Colors.green,
                        ),
                      );
                    },
                  ),
                if (schemes.isNotEmpty)
                  Text(
                    "that's all you got !",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: w * .03,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                SizedBox(height: h * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }
}
