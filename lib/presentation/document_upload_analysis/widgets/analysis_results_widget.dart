import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnalysisResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  final VoidCallback onBackToUpload;

  const AnalysisResultsWidget({
    super.key,
    required this.results,
    required this.onBackToUpload,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success Header
          _buildSuccessHeader(),

          SizedBox(height: 24),

          // Executive Summary
          _buildSummaryCard(),

          SizedBox(height: 16),

          // Detailed Findings
          _buildFindingsCard(),

          SizedBox(height: 16),

          // Recommendations
          _buildRecommendationsCard(),

          SizedBox(height: 16),

          // Compliance Notes
          _buildComplianceCard(),

          SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.getSuccessColor(true),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'تم التحليل بنجاح',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.getSuccessColor(true),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'تم تحليل الوثيقة وفقاً للقانون المصري',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return _buildResultCard(
      title: 'الملخص التنفيذي',
      icon: 'summarize',
      content: results["executiveSummary"] as String,
      color: AppTheme.lightTheme.primaryColor,
    );
  }

  Widget _buildFindingsCard() {
    final findings = results["detailedFindings"] as List;

    return _buildResultCard(
      title: 'النتائج التفصيلية',
      icon: 'search',
      color: Color(0xFF2B6CB0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: findings.map<Widget>((finding) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF2B6CB0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    finding as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = results["recommendations"] as List;

    return _buildResultCard(
      title: 'التوصيات',
      icon: 'lightbulb',
      color: AppTheme.getWarningColor(true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recommendations.map<Widget>((recommendation) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'arrow_left',
                  color: AppTheme.getWarningColor(true),
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildComplianceCard() {
    return _buildResultCard(
      title: 'ملاحظات الامتثال',
      icon: 'verified',
      content: results["complianceNotes"] as String,
      color: AppTheme.getSuccessColor(true),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String icon,
    required Color color,
    String? content,
    Widget? child,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.getBorderColor(true),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (content != null)
            Text(
              content,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              // Mock download functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'download',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'تحميل التقرير',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: onBackToUpload,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.primaryColor,
              side: BorderSide(
                color: AppTheme.lightTheme.primaryColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'upload_file',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'تحليل وثيقة جديدة',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
