import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isMessageEmpty;
  final bool canSendMessage;
  final VoidCallback onSendPressed;
  final VoidCallback onMicPressed;

  const MessageInputWidget({
    super.key,
    required this.controller,
    required this.isMessageEmpty,
    required this.canSendMessage,
    required this.onSendPressed,
    required this.onMicPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.getShadowColor(true),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!canSendMessage) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        AppTheme.getWarningColor(true).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info',
                      color: AppTheme.getWarningColor(true),
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'لقد استنفدت الاستفسارات المجانية لهذا الشهر. قم بالترقية للمتابعة.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getWarningColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                // Microphone Button
                GestureDetector(
                  onTap: canSendMessage ? onMicPressed : null,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: canSendMessage
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1)
                          : AppTheme.getBorderColor(true),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: canSendMessage
                            ? AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3)
                            : AppTheme.getBorderColor(true),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'mic',
                      color: canSendMessage
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Text Input Field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.getBorderColor(true),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      enabled: canSendMessage,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: canSendMessage
                            ? 'اطرح سؤالك القانوني هنا...'
                            : 'قم بالترقية للمتابعة',
                        hintStyle:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 3.w,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Send Button
                GestureDetector(
                  onTap: (!isMessageEmpty && canSendMessage)
                      ? onSendPressed
                      : null,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: (!isMessageEmpty && canSendMessage)
                          ? AppTheme.lightTheme.primaryColor
                          : AppTheme.getBorderColor(true),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: 'send',
                      color: (!isMessageEmpty && canSendMessage)
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
