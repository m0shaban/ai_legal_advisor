import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/template_card_widget.dart';

class LegalTemplatesLibrary extends StatefulWidget {
  const LegalTemplatesLibrary({super.key});

  @override
  _LegalTemplatesLibraryState createState() => _LegalTemplatesLibraryState();
}

class _LegalTemplatesLibraryState extends State<LegalTemplatesLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  List<String> _selectedCategories = [];
  String _selectedDocumentType = 'All';
  String _selectedComplexityLevel = 'All';

  // Mock data for legal templates
  final List<Map<String, dynamic>> _allTemplates = [
    {
      "id": 1,
      "name": "عقد عمل موظف",
      "nameEn": "Employee Contract",
      "category": "Employment Contracts",
      "categoryAr": "عقود العمل",
      "description":
          "عقد عمل شامل للموظفين في القطاع الخاص مع جميع البنود القانونية المطلوبة",
      "isPremium": false,
      "documentType": "Contract",
      "complexityLevel": "Medium",
      "downloadCount": 1250,
      "isFavorite": false,
      "fileSize": "2.5 MB",
      "lastUpdated": "2024-01-15"
    },
    {
      "id": 2,
      "name": "اتفاقية شراكة تجارية",
      "nameEn": "Business Partnership Agreement",
      "category": "Business Agreements",
      "categoryAr": "الاتفاقيات التجارية",
      "description":
          "اتفاقية شراكة شاملة للأعمال التجارية مع توزيع الأرباح والمسؤوليات",
      "isPremium": true,
      "documentType": "Agreement",
      "complexityLevel": "High",
      "downloadCount": 890,
      "isFavorite": true,
      "fileSize": "3.2 MB",
      "lastUpdated": "2024-01-20"
    },
    {
      "id": 3,
      "name": "عقد بيع عقار",
      "nameEn": "Property Sale Contract",
      "category": "Property Documents",
      "categoryAr": "وثائق العقارات",
      "description":
          "عقد بيع عقار معتمد وفقاً للقانون المصري مع جميع الضمانات القانونية",
      "isPremium": true,
      "documentType": "Contract",
      "complexityLevel": "High",
      "downloadCount": 2100,
      "isFavorite": false,
      "fileSize": "4.1 MB",
      "lastUpdated": "2024-01-18"
    },
    {
      "id": 4,
      "name": "توكيل عام",
      "nameEn": "General Power of Attorney",
      "category": "Personal Legal Forms",
      "categoryAr": "النماذج القانونية الشخصية",
      "description": "توكيل عام شامل للتصرف في الأمور القانونية والمالية",
      "isPremium": false,
      "documentType": "Form",
      "complexityLevel": "Low",
      "downloadCount": 3200,
      "isFavorite": true,
      "fileSize": "1.8 MB",
      "lastUpdated": "2024-01-22"
    },
    {
      "id": 5,
      "name": "عقد إيجار سكني",
      "nameEn": "Residential Lease Agreement",
      "category": "Property Documents",
      "categoryAr": "وثائق العقارات",
      "description": "عقد إيجار سكني متوافق مع قانون الإيجار الجديد في مصر",
      "isPremium": false,
      "documentType": "Contract",
      "complexityLevel": "Medium",
      "downloadCount": 4500,
      "isFavorite": false,
      "fileSize": "2.8 MB",
      "lastUpdated": "2024-01-25"
    },
    {
      "id": 6,
      "name": "اتفاقية عدم إفشاء",
      "nameEn": "Non-Disclosure Agreement",
      "category": "Business Agreements",
      "categoryAr": "الاتفاقيات التجارية",
      "description": "اتفاقية عدم إفشاء المعلومات السرية للشركات والأعمال",
      "isPremium": true,
      "documentType": "Agreement",
      "complexityLevel": "Medium",
      "downloadCount": 1800,
      "isFavorite": false,
      "fileSize": "2.2 MB",
      "lastUpdated": "2024-01-12"
    }
  ];

  List<Map<String, dynamic>> _filteredTemplates = [];

  final List<String> _categories = [
    'Employment Contracts',
    'Business Agreements',
    'Property Documents',
    'Personal Legal Forms'
  ];

  final Map<String, String> _categoryTranslations = {
    'Employment Contracts': 'عقود العمل',
    'Business Agreements': 'الاتفاقيات التجارية',
    'Property Documents': 'وثائق العقارات',
    'Personal Legal Forms': 'النماذج القانونية الشخصية'
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredTemplates = List.from(_allTemplates);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _isSearching = _searchQuery.isNotEmpty;
      _filterTemplates();
    });
  }

  void _filterTemplates() {
    setState(() {
      _filteredTemplates = _allTemplates.where((template) {
        bool matchesSearch = _searchQuery.isEmpty ||
            (template['name'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (template['nameEn'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            (template['description'] as String)
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());

        bool matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.contains(template['category']);

        bool matchesDocumentType = _selectedDocumentType == 'All' ||
            template['documentType'] == _selectedDocumentType;

        bool matchesComplexity = _selectedComplexityLevel == 'All' ||
            template['complexityLevel'] == _selectedComplexityLevel;

        return matchesSearch &&
            matchesCategory &&
            matchesDocumentType &&
            matchesComplexity;
      }).toList();
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _filteredTemplates = List.from(_allTemplates);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        categories: _categories,
        categoryTranslations: _categoryTranslations,
        selectedCategories: _selectedCategories,
        selectedDocumentType: _selectedDocumentType,
        selectedComplexityLevel: _selectedComplexityLevel,
        onFiltersChanged: (categories, documentType, complexityLevel) {
          setState(() {
            _selectedCategories = categories;
            _selectedDocumentType = documentType;
            _selectedComplexityLevel = complexityLevel;
            _filterTemplates();
          });
        },
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategories.clear();
      _selectedDocumentType = 'All';
      _selectedComplexityLevel = 'All';
      _filteredTemplates = List.from(_allTemplates);
    });
  }

  void _onTemplateAction(Map<String, dynamic> template, String action) {
    switch (action) {
      case 'download':
        _downloadTemplate(template);
        break;
      case 'favorite':
        _toggleFavorite(template);
        break;
      case 'share':
        _shareTemplate(template);
        break;
      case 'preview':
        _previewTemplate(template);
        break;
    }
  }

  void _downloadTemplate(Map<String, dynamic> template) {
    if (template['isPremium'] == true) {
      _showUpgradeDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحميل ${template['name']}'),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );
    }
  }

  void _toggleFavorite(Map<String, dynamic> template) {
    setState(() {
      template['isFavorite'] = !(template['isFavorite'] as bool);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(template['isFavorite']
            ? 'تم إضافة ${template['name']} للمفضلة'
            : 'تم إزالة ${template['name']} من المفضلة'),
      ),
    );
  }

  void _shareTemplate(Map<String, dynamic> template) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم مشاركة ${template['name']}')),
    );
  }

  void _previewTemplate(Map<String, dynamic> template) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('معاينة ${template['name']}')),
    );
  }

  void _showUpgradeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'star',
              color: AppTheme.getAccentColor(true),
              size: 24,
            ),
            SizedBox(width: 8),
            Text('ترقية للنسخة المميزة'),
          ],
        ),
        content: Text(
          'هذا القالب متاح للمشتركين المميزين فقط. قم بالترقية للوصول إلى جميع القوالب المتقدمة.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to subscription screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getAccentColor(true),
              foregroundColor: Colors.black,
            ),
            child: Text('ترقية الآن'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'مكتبة القوالب القانونية',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 2,
          leading: IconButton(
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'القوالب'),
              Tab(text: 'المفضلة'),
              Tab(text: 'المحملة'),
              Tab(text: 'الحديثة'),
            ],
            labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
            unselectedLabelColor: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.7),
            indicatorColor: AppTheme.getAccentColor(true),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Search and Filter Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.getShadowColor(true),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          hintText: 'البحث في القوالب...',
                          hintStyle: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                          prefixIcon: CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          suffixIcon: _isSearching
                              ? IconButton(
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(true),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.getBorderColor(true),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: 'filter_list',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 24,
                        ),
                        onPressed: _showFilterBottomSheet,
                      ),
                    ),
                  ],
                ),
              ),

              // Active Filters Display
              if (_selectedCategories.isNotEmpty ||
                  _selectedDocumentType != 'All' ||
                  _selectedComplexityLevel != 'All')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ..._selectedCategories.map((category) => Chip(
                            label: Text(
                                _categoryTranslations[category] ?? category),
                            onDeleted: () {
                              setState(() {
                                _selectedCategories.remove(category);
                                _filterTemplates();
                              });
                            },
                            backgroundColor: AppTheme
                                .lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            labelStyle: AppTheme.lightTheme.textTheme.bodySmall,
                          )),
                      if (_selectedDocumentType != 'All')
                        Chip(
                          label: Text(_selectedDocumentType),
                          onDeleted: () {
                            setState(() {
                              _selectedDocumentType = 'All';
                              _filterTemplates();
                            });
                          },
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          labelStyle: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      if (_selectedComplexityLevel != 'All')
                        Chip(
                          label: Text(_selectedComplexityLevel),
                          onDeleted: () {
                            setState(() {
                              _selectedComplexityLevel = 'All';
                              _filterTemplates();
                            });
                          },
                          backgroundColor: AppTheme.getWarningColor(true)
                              .withValues(alpha: 0.1),
                          labelStyle: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      TextButton(
                        onPressed: _clearFilters,
                        style: TextButton.styleFrom(
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.error,
                        ),
                        child: Text('مسح الفلاتر'),
                      ),
                    ],
                  ),
                ),

              // Templates List
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // All Templates Tab
                    _buildTemplatesList(_filteredTemplates),
                    // Favorites Tab
                    _buildTemplatesList(_filteredTemplates
                        .where((template) => template['isFavorite'] == true)
                        .toList()),
                    // Downloaded Tab
                    _buildTemplatesList([]), // Empty for demo
                    // Recent Tab
                    _buildTemplatesList(_filteredTemplates.take(3).toList()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplatesList(List<Map<String, dynamic>> templates) {
    if (_isLoading) {
      return _buildSkeletonLoader();
    }

    if (templates.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return TemplateCardWidget(
            template: template,
            onAction: _onTemplateAction,
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.getBorderColor(true),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.getBorderColor(true),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: AppTheme.getBorderColor(true),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.getBorderColor(true),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 4),
              Container(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: AppTheme.getBorderColor(true),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'description',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد قوالب',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'لم يتم العثور على قوالب تطابق البحث',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _clearFilters,
            child: Text('مسح الفلاتر'),
          ),
        ],
      ),
    );
  }
}
