import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorText extends StatelessWidget {
  final dynamic errorText;
  const ErrorText({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final shouldCopy = await context.showConfirmationDialog(
          title: 'Confirm Action',
          message: 'Do you want to copy?',
          confirmText: 'Yes',
        );

        if (shouldCopy == true) {
          Clipboard.setData(ClipboardData(text: errorText.toString()));
          context.showSuccessSnackBar('Content copied to clipboard');
        }
      },
      child: Center(child: Text(errorText.toString())),
    );
  }
}
