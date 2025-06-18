import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/onboarding_slide_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  _OnboardingCarouselState createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "id": 1,
      "title": "القانون والذكاء الاصطناعي",
      "description": "استشارات قانونية مدعومة بالذكاء الاصطناعي لمواكبة التطور.",
      "illustration": "assets/images/onboarding_law_ai.jpeg",
      "slideNumber": "١"
    },
    {
      "id": 2,
      "title": "القانون الدولي والتكنولوجيا",
      "description": "حلول قانونية تجمع بين التقنية والقوانين الدولية.",
      "illustration": "assets/images/onboarding_global_tech.jpeg",
      "slideNumber": "٢"
    },
    {
      "id": 3,
      "title": "الكتب والذكاء الاصطناعي",
      "description": "مصادر معرفية متجددة تجمع بين الكتب التقليدية والذكاء الاصطناعي.",
      "illustration": "assets/images/onboarding_books_ai.jpeg",
      "slideNumber": "٣"
    },
    {
      "id": 4,
      "title": "حماية سرية البيانات",
      "description": "أمان وحماية لبياناتك القانونية والمستندات الحساسة.",
      "illustration": "assets/images/onboarding_privacy.jpeg",
      "slideNumber": "٤"
    },
    {
      "id": 5,
      "title": "تحليل المستندات بالذكاء الاصطناعي",
      "description": "قم برفع مستنداتك القانونية واحصل على تحليل ذكي وفوري.",
      "illustration": "assets/images/onboarding_doc_analysis.jpeg",
      "slideNumber": "٥"
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'تخطي',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
              ),

              // Carousel content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final slideData = _onboardingData[index];
                    return OnboardingSlideWidget(
                      title: slideData['title'] as String,
                      description: slideData['description'] as String,
                      illustration: slideData['illustration'] as String,
                      slideNumber: slideData['slideNumber'] as String,
                      isDisclaimer: slideData['isDisclaimer'] as bool? ?? false,
                    );
                  },
                ),
              ),

              // Page indicators
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: PageIndicatorWidget(
                  currentPage: _currentPage,
                  totalPages: _onboardingData.length,
                ),
              ),

              // Navigation buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _currentPage == _onboardingData.length - 1
                          ? ElevatedButton(
                              onPressed: _completeOnboarding,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 4.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'ابدأ الآن',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _nextPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 4.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'التالي',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
