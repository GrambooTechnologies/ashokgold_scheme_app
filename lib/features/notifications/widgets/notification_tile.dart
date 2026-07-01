import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/features/notifications/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isUnread
            ? Palette.primaryColor.withOpacity(0.05)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.045,
          vertical: w * 0.04,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type icon ──────────────────────────────────────────────────
            Container(
              width: w * 0.11,
              height: w * 0.11,
              decoration: BoxDecoration(
                color: _typeColor(
                  notification.notificationType,
                ).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _typeIcon(notification.notificationType),
                color: _typeColor(notification.notificationType),
                size: w * 0.055,
              ),
            ),

            SizedBox(width: w * 0.03),

            // ── Text content ───────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Unread dot
                      if (isUnread) ...[
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6, top: 2),
                          decoration: const BoxDecoration(
                            color: Palette.buttonColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: w * 0.038,
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: Palette.blackColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.01),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.033,
                      fontWeight: FontWeight.w400,
                      color: Palette.hintTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: w * 0.015),
                  Row(
                    children: [
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _typeColor(
                            notification.notificationType,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _typeLabel(notification.notificationType),
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: w * 0.026,
                            fontWeight: FontWeight.w600,
                            color: _typeColor(notification.notificationType),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Timestamp
                      Text(
                        FormatDateTime.isoStringToDDMMMYYYYWithTime(
                          notification.createdAt,
                          true,
                        ),
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: w * 0.028,
                          color: Palette.hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  IconData _typeIcon(String type) {
    switch (type) {
      case NotificationType.payment:
        return Icons.payments_rounded;
      case NotificationType.scheme:
        return Icons.layers_rounded;
      case NotificationType.promotion:
        return Icons.local_offer_rounded;
      case NotificationType.system:
        return Icons.settings_rounded;
      case NotificationType.general:
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case NotificationType.payment:
        return Colors.green;
      case NotificationType.scheme:
        return Palette.primaryColor;
      case NotificationType.promotion:
        return Colors.orange;
      case NotificationType.system:
        return Colors.blueGrey;
      case NotificationType.general:
      default:
        return Palette.buttonColor;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case NotificationType.payment:
        return 'Payment';
      case NotificationType.scheme:
        return 'Scheme';
      case NotificationType.promotion:
        return 'Offer';
      case NotificationType.system:
        return 'System';
      case NotificationType.general:
      default:
        return 'General';
    }
  }
}
