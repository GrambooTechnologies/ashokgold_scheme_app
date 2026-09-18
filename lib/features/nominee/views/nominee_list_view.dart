import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_floating_button.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/login_required_widget.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/noItems_list_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/auth_guard.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/nominee/controllers/nominee_controller.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/nominee/providers/nominee_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/views/add_edit_nominee_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NomineeListView extends ConsumerWidget {
  static const String routeName = '/nominees';
  const NomineeListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check authentication
    if (!AuthGuard.requireAuth(context, ref)) {
      return const LoginRequiredWidget(
        title: 'My Nominees',
        message: 'Please login to manage your nominees.',
        icon: Icons.lock_outline,
      );
    }

    final nomineesAsync = ref.watch(nomineeListProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        title: Text(
          'My Nominees',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 20),
          ),
        ),
        centerTitle: true,
      ),
      body: nomineesAsync.when(
        data: (List<CustomerNomineeModel> nominees) {
          if (nominees.isEmpty) {
            return const NoItemsWidget(message: 'No nominees added yet');
          }
          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(nomineeListProvider.notifier).refreshList();
            },
            child: ListView.builder(
              padding: EdgeInsets.all(SizeConfig.w(context, 16)),
              itemCount: nominees.length,
              itemBuilder: (BuildContext context, int index) {
                final nominee = nominees[index];
                return _buildNomineeCard(context, ref, nominee);
              },
            ),
          );
        },
        loading: () => const Loader(),
        error: (Object error, StackTrace stack) => ErrorRetryWidget(
          message: 'Failed to load nominees',
          onRetry: () {
            ref.invalidate(nomineeListProvider);
          },
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        isLoading: false,
        text: "Add Nominee",
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push(AddEditNomineeView.routeName);
        },
      ),
    );
  }

  Widget _buildNomineeCard(
    BuildContext context,
    WidgetRef ref,
    CustomerNomineeModel nominee,
  ) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.only(bottom: SizeConfig.h(context, 12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.w(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Palette.primaryColor.withValues(alpha: 0.1),
                  child: Icon(Icons.person, color: Palette.primaryColor),
                ),
                SizedBox(width: SizeConfig.w(context, 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nominee.nomineeName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.w(context, 16),
                        ),
                      ),
                      Text(
                        nominee.nomineeRelation.relationName,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: SizeConfig.w(context, 14),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) async {
                    if (value == 'edit') {
                      context.push(
                        AddEditNomineeView.routeName,
                        extra: nominee,
                      );
                    } else if (value == 'delete') {
                      final shouldDelete = await context.showConfirmationDialog(
                        title: 'Delete Nominee',
                        message:
                            'Are you sure you want to delete ${nominee.nomineeName}?',
                      );
                      if (shouldDelete == true && context.mounted) {
                        await ref
                            .read(nomineeControllerProvider.notifier)
                            .deleteNominee(
                              nomineeId: nominee.nomineeId,
                              context: context,
                            );
                      }
                    }
                  },
                ),
              ],
            ),
            if (nominee.nomineeMobile != null) ...[
              SizedBox(height: SizeConfig.h(context, 12)),
              Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: SizeConfig.w(context, 16),
                    color: Colors.grey.shade600,
                  ),
                  SizedBox(width: SizeConfig.w(context, 8)),
                  Text(
                    nominee.nomineeMobile!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: SizeConfig.w(context, 14),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
