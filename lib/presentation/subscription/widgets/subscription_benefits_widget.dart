import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubscriptionBenefitsWidget extends StatelessWidget {
  const SubscriptionBenefitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'مزايا الاشتراك المميز',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkTextColor,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          ..._benefits.map((benefit) => _buildBenefitItem(benefit)),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(BenefitItem benefit) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(1.5.w),
            decoration: BoxDecoration(
              color: benefit.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              benefit.icon,
              color: benefit.color,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkTextColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  benefit.description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static final List<BenefitItem> _benefits = [
    BenefitItem(
      icon: Icons.chat_bubble_outline,
      title: 'استشارات قانونية غير محدودة',
      description: 'احصل على إجابات قانونية مفصلة لجميع استفساراتك دون قيود',
      color: Colors.blue,
    ),
    BenefitItem(
      icon: Icons.document_scanner_outlined,
      title: 'تحليل الوثائق المتقدم',
      description: 'رفع وتحليل العقود والوثائق القانونية بدقة عالية',
      color: Colors.green,
    ),
    BenefitItem(
      icon: Icons.library_books_outlined,
      title: 'مكتبة النماذج القانونية',
      description: 'الوصول الكامل لجميع النماذج والعقود القانونية',
      color: Colors.orange,
    ),
    BenefitItem(
      icon: Icons.priority_high_outlined,
      title: 'دعم أولوية',
      description: 'استجابة سريعة ودعم فني متقدم على مدار الساعة',
      color: Colors.red,
    ),
    BenefitItem(
      icon: Icons.cloud_sync_outlined,
      title: 'حفظ تلقائي ومزامنة',
      description: 'حفظ جميع محادثاتك ووثائقك في السحابة بأمان',
      color: Colors.purple,
    ),
    BenefitItem(
      icon: Icons.update_outlined,
      title: 'تحديثات قانونية مستمرة',
      description: 'احصل على آخر التحديثات في القوانين والأنظمة',
      color: Colors.teal,
    ),
  ];
}

class BenefitItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
