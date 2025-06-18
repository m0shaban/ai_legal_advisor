import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final String title;
  final String description;
  final String illustration;
  final String slideNumber;
  final bool isDisclaimer;

  const OnboardingSlideWidget({
    super.key,
    required this.title,
    required this.description,
    required this.illustration,
    required this.slideNumber,
    this.isDisclaimer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Slide number indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isDisclaimer
                  ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDisclaimer
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                slideNumber,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: isDisclaimer
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h), // تقليل من 4.h إلى 3.h

          // Illustration
          Container(
            width: 70.w,
            height: 30.h, // تقليل الارتفاع من 35.h إلى 30.h
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CustomImageWidget(
                imageUrl: illustration,
                width: 70.w,
                height: 30.h, // تقليل الارتفاع من 35.h إلى 30.h
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 3.h), // تقليل من 4.h إلى 3.h

          // Title with disclaimer styling
          Container(
            padding: isDisclaimer ? EdgeInsets.all(4.w) : EdgeInsets.zero,
            decoration: isDisclaimer
                ? BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.2),
                      width: 1,
                    ),
                  )
                : null,
            child: Column(
              children: [
                if (isDisclaimer)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'warning',
                        color: AppTheme.lightTheme.colorScheme.error,
                        size: 24,
                      ),
                      SizedBox(width: 2.w),
                    ],
                  ),
                if (isDisclaimer) SizedBox(height: 2.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: isDisclaimer
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Description
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.6,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: 4.h), // تقليل من 6.h إلى 4.h
        ],
        ),
      ),
    );
  }
}
