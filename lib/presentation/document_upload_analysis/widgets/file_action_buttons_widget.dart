import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class FileActionButtonsWidget extends StatelessWidget {
  final VoidCallback onChooseFile;
  final VoidCallback onTakePhoto;
  final VoidCallback onScanDocument;

  const FileActionButtonsWidget({
    super.key,
    required this.onChooseFile,
    required this.onTakePhoto,
    required this.onScanDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: 'folder_open',
            label: 'اختيار ملف',
            onTap: onChooseFile,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: 'camera_alt',
            label: 'التقاط صورة',
            onTap: onTakePhoto,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: 'document_scanner',
            label: 'مسح الوثيقة',
            onTap: onScanDocument,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.getBorderColor(true),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.primaryColor,
                  size: 20,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
