import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/utilities/scale_size_utils.dart';

class UnauthorizedPromptWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? actionButtonText;

  const UnauthorizedPromptWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.actionButtonText = "Try Again",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 24)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(SizeConfig.w(context, 32)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SizeConfig.w(context, 20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: SizeConfig.w(context, 30),
                spreadRadius: 0,
                offset: Offset(0, SizeConfig.h(context, 8)),
              ),
            ],
            border: Border.all(
              color: Palette.primaryColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with background
              Container(
                width: SizeConfig.w(context, 100),
                height: SizeConfig.w(context, 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.primaryColor.withOpacity(0.1),
                      Palette.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Palette.primaryColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: Palette.primaryColor,
                  size: SizeConfig.w(context, 48),
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 24)),

              // Title with better styling
              Text(
                "Access Restricted",
                style: Palette.customTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.w(context, 26),
                  color: Palette.primaryColor,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 12)),

              // Divider line
              Container(
                width: SizeConfig.w(context, 60),
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.primaryColor.withOpacity(0.3),
                      Palette.primaryColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 20)),

              // Message with enhanced container
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.w(context, 20),
                  vertical: SizeConfig.h(context, 16),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius:
                      BorderRadius.circular(SizeConfig.w(context, 16)),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  message,
                  style: Palette.customTextStyle.copyWith(
                    fontSize: SizeConfig.w(context, 16),
                    color: Colors.grey[700],
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 32)),

              // Action buttons
              Row(
                children: [
                  // Go Back Button
                  Expanded(
                    child: Container(
                      height: SizeConfig.h(context, 52),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.w(context, 16)),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.5,
                        ),
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.w(context, 16)),
                          onTap: () => Navigator.of(context).pop(),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: SizeConfig.w(context, 18),
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: SizeConfig.w(context, 8)),
                                Text(
                                  "Go Back",
                                  style: Palette.customTextStyle.copyWith(
                                    fontSize: SizeConfig.w(context, 16),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (onRetry != null) ...[
                    SizedBox(width: SizeConfig.w(context, 16)),

                    // Retry Button
                    Expanded(
                      child: Container(
                        height: SizeConfig.h(context, 52),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Palette.primaryColor,
                              Palette.primaryColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.w(context, 16)),
                          boxShadow: [
                            BoxShadow(
                              color: Palette.primaryColor.withOpacity(0.3),
                              blurRadius: SizeConfig.w(context, 12),
                              offset: Offset(0, SizeConfig.h(context, 4)),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.w(context, 16)),
                            onTap: onRetry,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: SizeConfig.w(context, 20),
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: SizeConfig.w(context, 8)),
                                  Text(
                                    actionButtonText!,
                                    style: Palette.customTextStyle.copyWith(
                                      fontSize: SizeConfig.w(context, 16),
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Help text
              SizedBox(height: SizeConfig.h(context, 24)),
              // Text(
              //   "Need help? Contact support",
              //   style: Palette.customTextStyle.copyWith(
              //     fontSize: SizeConfig.w(context, 14),
              //     color: Colors.grey[500],
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
