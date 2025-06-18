import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import './widgets/analysis_options_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/file_action_buttons_widget.dart';
import './widgets/file_format_info_widget.dart';
import './widgets/selected_files_list_widget.dart';
import './widgets/upload_drop_zone_widget.dart';
import './widgets/upload_progress_widget.dart';

class DocumentUploadAnalysis extends StatefulWidget {
  const DocumentUploadAnalysis({super.key});

  @override
  _DocumentUploadAnalysisState createState() => _DocumentUploadAnalysisState();
}

class _DocumentUploadAnalysisState extends State<DocumentUploadAnalysis> {
  // Mock data for selected files
  List<Map<String, dynamic>> selectedFiles = [];

  // Mock data for analysis options
  List<Map<String, dynamic>> analysisOptions = [
    {
      "id": "contract_review",
      "title": "مراجعة العقد",
      "isSelected": false,
    },
    {
      "id": "legal_compliance",
      "title": "فحص الامتثال القانوني",
      "isSelected": false,
    },
    {
      "id": "risk_assessment",
      "title": "تقييم المخاطر",
      "isSelected": false,
    },
  ];

  // Mock analysis results
  Map<String, dynamic> analysisResults = {
    "executiveSummary":
        "ملخص تنفيذي: تم تحليل الوثيقة بنجاح. العقد يحتوي على بنود قانونية سليمة مع بعض التوصيات للتحسين.",
    "detailedFindings": [
      "البند الأول: يحتاج إلى توضيح أكثر في شروط الدفع",
      "البند الثاني: مطابق للقانون المصري",
      "البند الثالث: يُنصح بإضافة شرط جزائي"
    ],
    "recommendations": [
      "إضافة شرط تحكيم واضح",
      "تحديد آلية حل النزاعات",
      "مراجعة شروط الإنهاء"
    ],
    "complianceNotes":
        "الوثيقة متوافقة مع القانون المدني المصري رقم ١٣١ لسنة ١٩٤٨"
  };

  bool isUploading = false;
  bool isAnalyzing = false;
  bool showResults = false;
  double uploadProgress = 0.0;
  String estimatedTime = "٢ دقيقة";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: showResults ? _buildResultsView() : _buildUploadView(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.primaryColor,
      elevation: 2.0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      title: Text(
        'تحليل الوثائق',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildUploadView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upload Drop Zone
          UploadDropZoneWidget(
            onFilesSelected: _handleFilesSelected,
          ),

          SizedBox(height: 24),

          // File Action Buttons
          FileActionButtonsWidget(
            onChooseFile: _handleChooseFile,
            onTakePhoto: _handleTakePhoto,
            onScanDocument: _handleScanDocument,
          ),

          SizedBox(height: 24),

          // File Format Info
          FileFormatInfoWidget(),

          SizedBox(height: 24),

          // Selected Files List
          if (selectedFiles.isNotEmpty) ...[
            SelectedFilesListWidget(
              files: selectedFiles,
              onRemoveFile: _handleRemoveFile,
            ),
            SizedBox(height: 24),
          ],

          // Upload Progress
          if (isUploading) ...[
            UploadProgressWidget(
              progress: uploadProgress,
              estimatedTime: estimatedTime,
            ),
            SizedBox(height: 24),
          ],

          // Analysis Options
          if (selectedFiles.isNotEmpty && !isUploading) ...[
            AnalysisOptionsWidget(
              options: analysisOptions,
              onOptionChanged: _handleAnalysisOptionChanged,
            ),
            SizedBox(height: 32),
          ],

          // Analyze Button
          if (selectedFiles.isNotEmpty && !isUploading) ...[
            _buildAnalyzeButton(),
            SizedBox(height: 16),
          ],

          // Processing State
          if (isAnalyzing) ...[
            _buildProcessingState(),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    bool hasSelectedOptions =
        analysisOptions.any((option) => option["isSelected"] == true);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: hasSelectedOptions ? _handleAnalyzeDocument : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.getAccentColor(true),
          foregroundColor: Colors.black,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'analytics',
              color: Colors.black,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'تحليل الوثيقة',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingState() {
    return Container(
      padding: EdgeInsets.all(24),
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
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'جاري تحليل الوثيقة...',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'الوقت المتوقع: $estimatedTime',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return AnalysisResultsWidget(
      results: analysisResults,
      onBackToUpload: () {
        setState(() {
          showResults = false;
          isAnalyzing = false;
          selectedFiles.clear();
          for (var option in analysisOptions) {
            option["isSelected"] = false;
          }
        });
      },
    );
  }

  void _handleFilesSelected(List<Map<String, dynamic>> files) {
    setState(() {
      selectedFiles.addAll(files);
    });
  }

  void _handleChooseFile() {
    // Mock file selection
    Map<String, dynamic> mockFile = {
      "name": "عقد_الإيجار.pdf",
      "size": "٢.٥ ميجابايت",
      "type": "PDF",
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    setState(() {
      selectedFiles.add(mockFile);
    });

    HapticFeedback.lightImpact();
  }

  void _handleTakePhoto() {
    // Mock photo capture
    Map<String, dynamic> mockFile = {
      "name": "صورة_الوثيقة.jpg",
      "size": "١.٨ ميجابايت",
      "type": "JPG",
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    setState(() {
      selectedFiles.add(mockFile);
    });

    HapticFeedback.lightImpact();
  }

  void _handleScanDocument() {
    // Mock document scan
    Map<String, dynamic> mockFile = {
      "name": "مسح_الوثيقة.pdf",
      "size": "٣.٢ ميجابايت",
      "type": "PDF",
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
    };

    setState(() {
      selectedFiles.add(mockFile);
    });

    HapticFeedback.lightImpact();
  }

  void _handleRemoveFile(String fileId) {
    setState(() {
      selectedFiles.removeWhere((file) => file["id"] == fileId);
    });

    HapticFeedback.lightImpact();
  }

  void _handleAnalysisOptionChanged(String optionId, bool isSelected) {
    setState(() {
      int index =
          analysisOptions.indexWhere((option) => option["id"] == optionId);
      if (index != -1) {
        analysisOptions[index]["isSelected"] = isSelected;
      }
    });
  }

  void _handleAnalyzeDocument() {
    setState(() {
      isAnalyzing = true;
    });

    // Simulate analysis process
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isAnalyzing = false;
          showResults = true;
        });
      }
    });

    HapticFeedback.mediumImpact();
  }
}
