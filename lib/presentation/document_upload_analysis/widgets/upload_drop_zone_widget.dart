import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class UploadDropZoneWidget extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onFilesSelected;

  const UploadDropZoneWidget({
    super.key,
    required this.onFilesSelected,
  });

  @override
  _UploadDropZoneWidgetState createState() => _UploadDropZoneWidgetState();
}

class _UploadDropZoneWidgetState extends State<UploadDropZoneWidget> {
  bool isDragOver = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: isDragOver
              ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05)
              : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDragOver
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.getBorderColor(true),
            width: isDragOver ? 2 : 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'cloud_upload',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 32,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'ارفع ملفات PDF أو DOCX للتحليل القانوني',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'اسحب الملفات هنا أو انقر للاختيار',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    // Mock file selection
    List<Map<String, dynamic>> mockFiles = [
      {
        "name": "وثيقة_قانونية.pdf",
        "size": "٤.٢ ميجابايت",
        "type": "PDF",
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
      }
    ];

    widget.onFilesSelected(mockFiles);
  }
}
