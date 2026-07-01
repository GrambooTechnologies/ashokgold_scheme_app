import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/noItems_list_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/payment_tries_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/providers/payment_tries_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentTriesView extends ConsumerWidget {
  static const String routeName = '/payment-tries';

  static String routePath(String joinId) => '/payment-tries/$joinId';

  final String joinId;

  const PaymentTriesView({super.key, required this.joinId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentTriesAsync = ref.watch(paymentTriesProvider(joinId));

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        title: Text(
          'Payment Attempts',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 17),
          ),
        ),
        centerTitle: true,
      ),
      body: paymentTriesAsync.when(
        data: (tries) {
          if (tries.isEmpty) {
            return const NoItemsWidget(message: 'No payment tries found');
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(paymentTriesProvider(joinId).notifier).refresh();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(SizeConfig.w(context, 16)),
              itemCount: tries.length,
              itemBuilder: (context, index) {
                return _buildPaymentTryCard(
                  context: context,
                  item: tries[index],
                  index: index,
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorRetryWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(paymentTriesProvider(joinId));
          },
        ),
      ),
    );
  }

  Widget _buildPaymentTryCard({
    required BuildContext context,
    required PaymentTriesItemModel item,
    required int index,
  }) {
    final statusColor = _statusColor(item.orderStatus);

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.h(context, 12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig.w(context, 16),
            offset: Offset(0, SizeConfig.h(context, 4)),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(context, 14),
          vertical: SizeConfig.h(context, 14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER: index circle + amount + status badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.w(context, 30),
                  height: SizeConfig.w(context, 30),
                  decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: SizeConfig.w(context, 12),
                      fontWeight: FontWeight.w700,
                      color: Palette.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.w(context, 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatCurrency(item.amount),
                        style: TextStyle(
                          fontSize: SizeConfig.w(context, 18),
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 3)),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.number,
                            size: SizeConfig.w(context, 11),
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: SizeConfig.w(context, 3)),
                          Expanded(
                            child: Text(
                              item.orderId,
                              style: TextStyle(
                                fontSize: SizeConfig.w(context, 11),
                                color: Colors.grey[500],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: item.orderId),
                              );
                              context.showInfoSnackBar('Order ID copied');
                            },
                            child: Icon(
                              CupertinoIcons.doc_on_clipboard,
                              size: SizeConfig.w(context, 13),
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: SizeConfig.w(context, 8)),
                _statusBadge(context, item.orderStatus, statusColor),
              ],
            ),

            SizedBox(height: SizeConfig.h(context, 12)),
            Divider(height: 1, color: Colors.grey[100]),
            SizedBox(height: SizeConfig.h(context, 10)),

            /// DATE ROW: Initiated On | Last Updated
            Row(
              children: [
                Expanded(
                  child: _dateItem(
                    context,
                    icon: CupertinoIcons.clock,
                    label: 'Initiated On',
                    value: FormatDateTime.isoStringToDDMMMYYYYWithTime(
                      item.createdAt,
                      true,
                    ),
                  ),
                ),
                if (item.updatedAt != null) ...[
                  Container(
                    width: 1,
                    height: SizeConfig.h(context, 34),
                    color: Colors.grey[200],
                  ),
                  Expanded(
                    child: _dateItem(
                      context,
                      icon: CupertinoIcons.arrow_clockwise,
                      label: 'Last Updated',
                      value: FormatDateTime.isoStringToDDMMMYYYYWithTime(
                        item.updatedAt!,
                        true,
                      ),
                      alignRight: true,
                    ),
                  ),
                ],
              ],
            ),

            /// CHIPS: transaction ID, voucher, payment status
            if (item.transactionId != null ||
                item.vchNo != null ||
                item.paymentStatus != null) ...[
              SizedBox(height: SizeConfig.h(context, 10)),
              Divider(height: 1, color: Colors.grey[100]),
              SizedBox(height: SizeConfig.h(context, 8)),
              _buildDetailRow(context, item),
            ],

            /// RESPONSE MESSAGE
            if (item.responseMessage != null) ...[
              SizedBox(height: SizeConfig.h(context, 8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(context, 10),
                  vertical: SizeConfig.h(context, 7),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.info_circle,
                      size: SizeConfig.w(context, 13),
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: SizeConfig.w(context, 6)),
                    Expanded(
                      child: Text(
                        item.responseMessage!,
                        style: TextStyle(
                          fontSize: SizeConfig.w(context, 11),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _dateItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool alignRight = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 4)),
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: alignRight
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!alignRight) ...[
                Icon(
                  icon,
                  size: SizeConfig.w(context, 11),
                  color: Colors.grey[400],
                ),
                SizedBox(width: SizeConfig.w(context, 3)),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 10),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
              if (alignRight) ...[
                SizedBox(width: SizeConfig.w(context, 3)),
                Icon(
                  icon,
                  size: SizeConfig.w(context, 11),
                  color: Colors.grey[400],
                ),
              ],
            ],
          ),
          SizedBox(height: SizeConfig.h(context, 2)),
          Text(
            value,
            style: TextStyle(
              fontSize: SizeConfig.w(context, 12),
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: alignRight ? TextAlign.end : TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, PaymentTriesItemModel item) {
    return Wrap(
      spacing: SizeConfig.w(context, 8),
      runSpacing: SizeConfig.h(context, 6),
      children: [
        if (item.transactionId != null)
          _copyableChip(
            context,
            icon: CupertinoIcons.arrow_right_arrow_left,
            label: 'Transaction ID',
            value: item.transactionId!,
          ),
        if (item.vchNo != null)
          _detailChip(
            context,
            icon: CupertinoIcons.doc_text,
            label: 'Voucher: ${item.vchNo}',
          ),
        if (item.vchDate != null)
          _detailChip(
            context,
            icon: CupertinoIcons.calendar,
            label:
                FormatDateTime.yyyymmddToDDMMMYYYY(item.vchDate) ??
                item.vchDate!,
          ),
        if (item.paymentStatus != null)
          _detailChip(
            context,
            icon: CupertinoIcons.creditcard,
            label: item.paymentStatus!,
            color: _statusColor(item.paymentStatus!),
          ),
      ],
    );
  }

  Widget _copyableChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final chipColor = color ?? Colors.grey[600]!;
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        context.showInfoSnackBar('$label copied');
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(context, 8),
          vertical: SizeConfig.h(context, 4),
        ),
        decoration: BoxDecoration(
          color: chipColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: SizeConfig.w(context, 11), color: chipColor),
            SizedBox(width: SizeConfig.w(context, 4)),
            Text(
              '$label: $value',
              style: TextStyle(
                fontSize: SizeConfig.w(context, 11),
                color: chipColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: SizeConfig.w(context, 4)),
            Icon(
              CupertinoIcons.doc_on_clipboard,
              size: SizeConfig.w(context, 11),
              color: chipColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final chipColor = color ?? Colors.grey[600]!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 8),
        vertical: SizeConfig.h(context, 4),
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: SizeConfig.w(context, 11), color: chipColor),
          SizedBox(width: SizeConfig.w(context, 4)),
          Text(
            label,
            style: TextStyle(
              fontSize: SizeConfig.w(context, 11),
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(BuildContext context, String status, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 8),
        vertical: SizeConfig.h(context, 3),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: SizeConfig.w(context, 11),
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _labelValue(
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
            fontSize: SizeConfig.w(context, 12),
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
      case 'PAID':
      case 'COMPLETED':
        return Colors.green;
      case 'FAILED':
      case 'FAILURE':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      case 'CREATED':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
