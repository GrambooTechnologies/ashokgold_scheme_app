import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/noItems_list_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/installment_history_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/providers/installment_history_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/payment_tries_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class InstallmentHistoryView extends ConsumerStatefulWidget {
  static const String routeName = '/installment-history';

  static String routePath(String joinId) => '/installment-history/$joinId';
  final String joinId;

  const InstallmentHistoryView({super.key, required this.joinId});

  @override
  ConsumerState<InstallmentHistoryView> createState() =>
      _InstallmentHistoryViewState();
}

class _InstallmentHistoryViewState
    extends ConsumerState<InstallmentHistoryView> {
  final Set<int> _expandedInstallments = {};

  String? joinId;

  @override
  void initState() {
    super.initState();
    joinId = stringOrNull(widget.joinId);
  }

  @override
  Widget build(BuildContext context) {
    final installmentHistoryAsync = ref.watch(
      installmentHistoryProvider(joinId!),
    );

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        title: Text(
          'Installment History',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 17),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Payment Tries',
            icon: Icon(
              CupertinoIcons.arrow_2_circlepath,
              size: SizeConfig.w(context, 22),
            ),
            onPressed: () {
              context.push(PaymentTriesView.routePath(joinId!));
            },
          ),
        ],
      ),
      body: installmentHistoryAsync.when(
        data: (installments) {
          if (installments.isEmpty) {
            return const NoItemsWidget(
              message: 'No installment history available',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(installmentHistoryProvider(joinId!).notifier)
                  .refresh();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(SizeConfig.w(context, 16)),
              itemCount: installments.length,
              itemBuilder: (context, index) {
                final installment = installments[index];
                return _buildInstallmentCard(
                  context: context,
                  installment: installment,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetryWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(installmentHistoryProvider(joinId!));
          },
        ),
      ),
    );
  }

  Widget _buildInstallmentCard({
    required BuildContext context,
    required InstallmentGroupModel installment,
  }) {
    final isExpanded = _expandedInstallments.contains(
      installment.installmentNumber,
    );

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.h(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig.w(context, 16),
            offset: Offset(0, SizeConfig.h(context, 4)),
          ),
        ],
      ),
      child: Column(
        children: [
          /// INSTALLMENT HEADER (tappable)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedInstallments.remove(installment.installmentNumber);
                } else {
                  _expandedInstallments.add(installment.installmentNumber);
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 14),
                vertical: SizeConfig.h(context, 12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.w(context, 8),
                          vertical: SizeConfig.h(context, 3),
                        ),
                        decoration: BoxDecoration(
                          color: Palette.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '#${installment.installmentNumber}',
                          style: TextStyle(
                            fontSize: SizeConfig.w(context, 13),
                            fontWeight: FontWeight.w800,
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(context, 8)),
                      Text(
                        '${installment.paymentEntries.length} payment(s)',
                        style: TextStyle(
                          fontSize: SizeConfig.w(context, 12),
                          color: Colors.grey[500],
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: SizeConfig.w(context, 22),
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.h(context, 10)),
                  Row(
                    children: [
                      Expanded(
                        child: _compactLabelValue(
                          context,
                          label: "Amount",
                          value: formatCurrency(installment.totalAmount),
                        ),
                      ),
                      Expanded(
                        child: _compactLabelValue(
                          context,
                          label: "Gold Weight",
                          value:
                              "${installment.totalGoldWeight.toStringAsFixed(8)} g",
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// EXPANDED PAYMENT ENTRIES
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: Colors.grey[200]),
                ...installment.paymentEntries.asMap().entries.map(
                  (mapEntry) => _buildPaymentEntryTile(
                    context: context,
                    entry: mapEntry.value,
                    isLast:
                        mapEntry.key == installment.paymentEntries.length - 1,
                  ),
                ),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentEntryTile({
    required BuildContext context,
    required InstallmentEntryItemModel entry,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 14),
        vertical: SizeConfig.h(context, 10),
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW: Date | Voucher | Status badge
          Row(
            children: [
              Icon(
                CupertinoIcons.calendar,
                size: SizeConfig.w(context, 13),
                color: Colors.grey[500],
              ),
              SizedBox(width: SizeConfig.w(context, 4)),
              Text(
                FormatDateTime.yyyymmddToDDMMMYYYY(entry.vchDate) ?? '',
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 12),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: SizeConfig.w(context, 8)),
              Text(
                entry.vchNo,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 11),
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(context, 8)),

          /// INFO GRID: Amount | Gold Weight | Gold Rate
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(context, 10),
              vertical: SizeConfig.h(context, 8),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _compactLabelValue(
                    context,
                    label: "Amount",
                    value: formatCurrency(entry.paymentAmount),
                  ),
                ),
                Container(
                  width: 1,
                  height: SizeConfig.h(context, 28),
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _compactLabelValue(
                    context,
                    label: "Gold Wt",
                    value: entry.goldWeight != null
                        ? "${entry.goldWeight!.toStringAsFixed(8)} g"
                        : "—",
                    center: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: SizeConfig.h(context, 28),
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _compactLabelValue(
                    context,
                    label: "Gold Rate",
                    value: entry.goldRate != null
                        ? "₹${entry.goldRate!.toStringAsFixed(2)}/g"
                        : "—",
                    alignRight: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactLabelValue(
    BuildContext context, {
    required String label,
    required String value,
    bool alignRight = false,
    bool center = false,
  }) {
    final alignment = center
        ? CrossAxisAlignment.center
        : alignRight
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 10),
            fontWeight: FontWeight.w500,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(height: SizeConfig.h(context, 2)),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 13),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
