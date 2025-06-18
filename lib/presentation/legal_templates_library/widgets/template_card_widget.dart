import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class TemplateCardWidget extends StatelessWidget {
  final Map<String, dynamic> template;
  final Function(Map<String, dynamic>, String) onAction;

  const TemplateCardWidget({
    super.key,
    required this.template,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPremium = template['isPremium'] ?? false;
    final bool isFavorite = template['isFavorite'] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium
              ? AppTheme.getAccentColor(true)
              : AppTheme.getBorderColor(true),
          width: isPremium ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.getShadowColor(true),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onAction(template, 'preview'),
        onLongPress: () => _showQuickActions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                template['name'] ?? '',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPremium) ...[
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.getAccentColor(true),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'مميز',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            template['categoryAr'] ??
                                template['category'] ??
                                '',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: isFavorite ? 'favorite' : 'favorite_border',
                          color: isFavorite
                              ? Colors.red
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                        onPressed: () => onAction(template, 'favorite'),
                      ),
                      IconButton(
                        icon: CustomIconWidget(
                          iconName: 'download',
                          color: isPremium
                              ? AppTheme.getAccentColor(true)
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                        onPressed: () => onAction(template, 'download'),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Description
              Text(
                template['description'] ?? '',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 16),

              // Footer Info
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${template['downloadCount']} تحميل',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 16),
                  CustomIconWidget(
                    iconName: 'folder',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    template['fileSize'] ?? '',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getComplexityColor(template['complexityLevel'])
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getComplexityText(template['complexityLevel']),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getComplexityColor(template['complexityLevel']),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.getBorderColor(true),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              template['name'] ?? '',
              style: AppTheme.lightTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  context,
                  'معاينة',
                  'visibility',
                  () => onAction(template, 'preview'),
                ),
                _buildQuickActionButton(
                  context,
                  'تحميل',
                  'download',
                  () => onAction(template, 'download'),
                ),
                _buildQuickActionButton(
                  context,
                  'مشاركة',
                  'share',
                  () => onAction(template, 'share'),
                ),
                _buildQuickActionButton(
                  context,
                  template['isFavorite'] == true ? 'إزالة' : 'مفضلة',
                  template['isFavorite'] == true
                      ? 'favorite'
                      : 'favorite_border',
                  () => onAction(template, 'favorite'),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    String iconName,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(28),
          ),
          child: IconButton(
            icon: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
              onPressed();
            },
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getComplexityColor(String? complexity) {
    switch (complexity) {
      case 'Low':
        return AppTheme.getSuccessColor(true);
      case 'Medium':
        return AppTheme.getWarningColor(true);
      case 'High':
        return Colors.red;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getComplexityText(String? complexity) {
    switch (complexity) {
      case 'Low':
        return 'بسيط';
      case 'Medium':
        return 'متوسط';
      case 'High':
        return 'معقد';
      default:
        return 'غير محدد';
    }
  }
}
