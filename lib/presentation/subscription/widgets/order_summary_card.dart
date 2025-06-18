import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryCard extends StatelessWidget {
  final SubscriptionPlan plan;
  final String? discountCode;
  final double discountAmount;

  const OrderSummaryCard({
    super.key,
    required this.plan,
    this.discountCode,
    this.discountAmount = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final subtotal = plan.price;
    final discount = discountAmount;
    final tax = (subtotal - discount) * 0.14; // 14% VAT
    final total = subtotal - discount + tax;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.receipt_outlined,
                color: AppTheme.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: 2.w),
              Text(
                'ملخص الطلب',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkTextColor,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 3.h),
          
          // Plan details
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkTextColor,
                        ),
                      ),
                      Text(
                        _getPeriodText(plan.duration),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  plan.price == 0 ? 'مجاني' : '\$${plan.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 3.h),
          
          // Price breakdown
          _buildPriceRow('المبلغ الفرعي', subtotal),
          
          if (discount > 0) ...[
            SizedBox(height: 1.h),
            _buildPriceRow(
              'خصم ($discountCode)',
              -discount,
              color: Colors.green,
              isDiscount: true,
            ),
          ],
          
          SizedBox(height: 1.h),
          _buildPriceRow('ضريبة القيمة المضافة (14%)', tax),
          
          SizedBox(height: 2.h),
          
          // Divider
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          
          SizedBox(height: 2.h),
          
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المجموع الكلي',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkTextColor,
                ),
              ),
              Text(
                total == 0 ? 'مجاني' : '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          
          if (plan.originalPrice != null && plan.originalPrice! > plan.price) ...[
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'توفير',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.green[700],
                  ),
                ),
                Text(
                  '\$${(plan.originalPrice! - plan.price).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
          
          SizedBox(height: 3.h),
          
          // Payment info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.blue[700],
                  size: 16.sp,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'سيتم تجديد الاشتراك تلقائياً. يمكنك إلغاؤه في أي وقت.',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    Color? color,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: color ?? Colors.grey[700],
          ),
        ),
        Text(
          isDiscount 
              ? '-\$${amount.abs().toStringAsFixed(2)}'
              : '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: color ?? AppTheme.darkTextColor,
          ),
        ),
      ],
    );
  }
  String _getPeriodText(String duration) {
    switch (duration.toLowerCase()) {
      case 'monthly':
        return 'اشتراك شهري';
      case 'yearly':
        return 'اشتراك سنوي';
      case 'lifetime':
        return 'مدى الحياة';
      default:
        return duration;
    }
  }
}
