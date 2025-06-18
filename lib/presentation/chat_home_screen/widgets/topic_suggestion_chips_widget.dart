import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TopicSuggestionChipsWidget extends StatelessWidget {
  final Function(String) onTopicSelected;

  const TopicSuggestionChipsWidget({
    super.key,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        "title": "مراجعة العقود",
        "icon": "description",
        "query":
            "أريد مراجعة عقد عمل. ما هي النقاط المهمة التي يجب التأكد منها؟"
      },
      {
        "title": "قانون العمل",
        "icon": "work",
        "query": "ما هي حقوقي كموظف وفقاً لقانون العمل المصري؟"
      },
      {
        "title": "حقوق الملكية",
        "icon": "home",
        "query": "كيف يمكنني حماية حقوق الملكية الخاصة بي؟"
      },
      {
        "title": "تأسيس الأعمال",
        "icon": "business",
        "query": "ما هي الخطوات القانونية لتأسيس شركة في مصر؟"
      },
      {
        "title": "القانون التجاري",
        "icon": "store",
        "query": "ما هي القوانين التجارية التي يجب معرفتها لبدء نشاط تجاري؟"
      },
      {
        "title": "قانون الأسرة",
        "icon": "family_restroom",
        "query": "ما هي الحقوق والواجبات في قانون الأحوال الشخصية المصري؟"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'مواضيع قانونية شائعة',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 12.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return Container(
                margin: EdgeInsets.only(left: 3.w),
                child: _buildTopicChip(
                  title: topic["title"] as String,
                  icon: topic["icon"] as String,
                  query: topic["query"] as String,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopicChip({
    required String title,
    required String icon,
    required String query,
  }) {
    return GestureDetector(
      onTap: () => onTopicSelected(query),
      child: Container(
        width: 35.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.getBorderColor(true),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.getShadowColor(true),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.primaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
