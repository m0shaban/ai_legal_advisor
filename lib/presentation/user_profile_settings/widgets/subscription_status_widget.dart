import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class SubscriptionStatusWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onManagePressed;

  const SubscriptionStatusWidget({
    super.key,
    required this.userData,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPro = userData['isPro'] ?? false;
    final String plan = userData['subscriptionPlan'] ?? 'Free';
    final String renewalDate = userData['renewalDate'] ?? '';

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isPro
            ? LinearGradient(
                colors: [
                  AppTheme.getAccentColor(true).withValues(alpha: 0.1),
                  AppTheme.getAccentColor(true).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isPro ? null : AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: isPro
            ? Border.all(
                color: AppTheme.getAccentColor(true).withValues(alpha: 0.3),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPro
                      ? AppTheme.getAccentColor(true).withValues(alpha: 0.2)
                      : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: isPro ? 'star' : 'person',
                  color: isPro
                      ? AppTheme.getAccentColor(true)
                      : AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة الاشتراك',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isPro ? 'الخطة المميزة' : 'الخطة المجانية',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isPro
                            ? AppTheme.getAccentColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isPro && renewalDate.isNotEmpty) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'تاريخ التجديد: $renewalDate',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onManagePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPro
                    ? AppTheme.getAccentColor(true)
                    : AppTheme.lightTheme.primaryColor,
                foregroundColor: isPro
                    ? Colors.black
                    : AppTheme.lightTheme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: isPro ? 'settings' : 'upgrade',
                    color: isPro
                        ? Colors.black
                        : AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    isPro ? 'إدارة الاشتراك' : 'ترقية إلى المميز',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: isPro
                          ? Colors.black
                          : AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isPro) ...[
            SizedBox(height: 12),
            Text(
              '• استشارات قانونية غير محدودة\n• تحليل الوثائق المتقدم\n• قوالب قانونية حصرية\n• دعم أولوية',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
