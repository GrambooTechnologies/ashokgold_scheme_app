import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/utilities/scale_size_utils.dart';
import '../../profile/views/contact_support_view.dart';

class ContactSupportButton extends StatelessWidget {
  const ContactSupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(ContactSupportView.routeName);
      },
      child: Container(
        height: SizeConfig.h(context, 42),
        margin: const EdgeInsets.symmetric(horizontal: 70),
        decoration: BoxDecoration(
          color: Palette.cardBackgroundColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(SizeConfig.w(context, 13)),
          border: Border.all(color: Palette.cardBackgroundColor, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contact us in case of any query ',
              style: TextStyle(
                color: Palette.primaryColor,
                fontSize: SizeConfig.w(context, 13),
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
    );
  }
}
