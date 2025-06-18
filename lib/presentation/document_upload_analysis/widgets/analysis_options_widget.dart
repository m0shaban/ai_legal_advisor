import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnalysisOptionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final Function(String, bool) onOptionChanged;

  const AnalysisOptionsWidget({
    super.key,
    required this.options,
    required this.onOptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'خيارات التحليل',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.getBorderColor(true),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: options.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = options[index];
                  return _buildOptionItem(option);
                },
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.getAccentColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.getAccentColor(true),
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'التحليل المتقدم متاح للمشتركين المميزين',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getAccentColor(true),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionItem(Map<String, dynamic> option) {
    return GestureDetector(
      onTap: () => onOptionChanged(
        option["id"] as String,
        !(option["isSelected"] as bool),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: (option["isSelected"] as bool)
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.transparent,
              border: Border.all(
                color: (option["isSelected"] as bool)
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.getBorderColor(true),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: (option["isSelected"] as bool)
                ? Center(
                    child: CustomIconWidget(
                      iconName: 'check',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 12,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              option["title"] as String,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (option["id"] == "risk_assessment") ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.getAccentColor(true),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'مميز',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
