import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final List<String> categories;
  final Map<String, String> categoryTranslations;
  final List<String> selectedCategories;
  final String selectedDocumentType;
  final String selectedComplexityLevel;
  final Function(List<String>, String, String) onFiltersChanged;

  const FilterBottomSheetWidget({
    super.key,
    required this.categories,
    required this.categoryTranslations,
    required this.selectedCategories,
    required this.selectedDocumentType,
    required this.selectedComplexityLevel,
    required this.onFiltersChanged,
  });

  @override
  _FilterBottomSheetWidgetState createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late List<String> _tempSelectedCategories;
  late String _tempSelectedDocumentType;
  late String _tempSelectedComplexityLevel;

  bool _isCategoryExpanded = true;
  bool _isDocumentTypeExpanded = false;
  bool _isComplexityExpanded = false;

  final List<String> _documentTypes = ['All', 'Contract', 'Agreement', 'Form'];
  final List<String> _complexityLevels = ['All', 'Low', 'Medium', 'High'];

  final Map<String, String> _documentTypeTranslations = {
    'All': 'الكل',
    'Contract': 'عقد',
    'Agreement': 'اتفاقية',
    'Form': 'نموذج',
  };

  final Map<String, String> _complexityTranslations = {
    'All': 'الكل',
    'Low': 'بسيط',
    'Medium': 'متوسط',
    'High': 'معقد',
  };

  @override
  void initState() {
    super.initState();
    _tempSelectedCategories = List.from(widget.selectedCategories);
    _tempSelectedDocumentType = widget.selectedDocumentType;
    _tempSelectedComplexityLevel = widget.selectedComplexityLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.getBorderColor(true),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    'تصفية القوالب',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'مسح الكل',
                      style: TextStyle(
                        color: AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1),

            // Filter Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories Section
                    _buildExpandableSection(
                      title: 'الفئات',
                      isExpanded: _isCategoryExpanded,
                      onToggle: () => setState(
                          () => _isCategoryExpanded = !_isCategoryExpanded),
                      child: Column(
                        children: widget.categories.map((category) {
                          final isSelected =
                              _tempSelectedCategories.contains(category);
                          return CheckboxListTile(
                            title: Text(
                              widget.categoryTranslations[category] ?? category,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _tempSelectedCategories.add(category);
                                } else {
                                  _tempSelectedCategories.remove(category);
                                }
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Document Type Section
                    _buildExpandableSection(
                      title: 'نوع الوثيقة',
                      isExpanded: _isDocumentTypeExpanded,
                      onToggle: () => setState(() =>
                          _isDocumentTypeExpanded = !_isDocumentTypeExpanded),
                      child: Column(
                        children: _documentTypes.map((type) {
                          final isSelected = _tempSelectedDocumentType == type;
                          return RadioListTile<String>(
                            title: Text(
                              _documentTypeTranslations[type] ?? type,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            value: type,
                            groupValue: _tempSelectedDocumentType,
                            onChanged: (value) {
                              setState(() {
                                _tempSelectedDocumentType = value ?? 'All';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Complexity Level Section
                    _buildExpandableSection(
                      title: 'مستوى التعقيد',
                      isExpanded: _isComplexityExpanded,
                      onToggle: () => setState(
                          () => _isComplexityExpanded = !_isComplexityExpanded),
                      child: Column(
                        children: _complexityLevels.map((level) {
                          final isSelected =
                              _tempSelectedComplexityLevel == level;
                          return RadioListTile<String>(
                            title: Text(
                              _complexityTranslations[level] ?? level,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                            value: level,
                            groupValue: _tempSelectedComplexityLevel,
                            onChanged: (value) {
                              setState(() {
                                _tempSelectedComplexityLevel = value ?? 'All';
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.getBorderColor(true),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('إلغاء'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      child: Text('تطبيق'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) ...[
          SizedBox(height: 8),
          child,
        ],
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _tempSelectedCategories.clear();
      _tempSelectedDocumentType = 'All';
      _tempSelectedComplexityLevel = 'All';
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(
      _tempSelectedCategories,
      _tempSelectedDocumentType,
      _tempSelectedComplexityLevel,
    );
    Navigator.pop(context);
  }
}
