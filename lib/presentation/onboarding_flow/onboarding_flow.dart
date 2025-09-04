import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/onboarding_navigation_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Scan Components',
      'description':
          'Use your camera to scan QR codes and barcodes on electronic components. Instantly identify parts and add them to your project inventory.',
      'iconName': 'qr_code_scanner',
      'color': AppTheme.lightTheme.colorScheme.primary,
      'showAnimation': true,
    },
    {
      'title': 'AI-Powered Ideas',
      'description':
          'Get creative project suggestions based on your available components. Our AI generates unique, feasible ideas tailored to your skill level.',
      'iconName': 'psychology',
      'color': AppTheme.lightTheme.colorScheme.tertiary,
      'showAnimation': true,
    },
    {
      'title': 'Build Your Library',
      'description':
          'Save your favorite project ideas, export detailed reports, and share innovations with your team. Track your STEM learning journey.',
      'iconName': 'folder_special',
      'color': AppTheme.lightTheme.colorScheme.secondary,
      'showAnimation': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    // Haptic feedback for page changes
    HapticFeedback.lightImpact();

    // Trigger animation for the current page
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    // Store onboarding completion status
    _storeOnboardingStatus();

    // Navigate to component selection dashboard
    Navigator.pushReplacementNamed(context, '/component-selection-dashboard');
  }

  Future<void> _storeOnboardingStatus() async {
    // This would typically store in SharedPreferences
    // For now, we'll just simulate the storage
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button in top right
            if (_currentPage < _onboardingData.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h, right: 4.w),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            else
              SizedBox(height: 6.h),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return OnboardingPageWidget(
                    title: data['title'],
                    description: data['description'],
                    iconName: data['iconName'],
                    iconColor: data['color'],
                    showAnimation:
                        data['showAnimation'] && index == _currentPage,
                  );
                },
              ),
            ),

            // Page indicator
            Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h),
              child: PageIndicatorWidget(
                currentPage: _currentPage,
                totalPages: _onboardingData.length,
              ),
            ),

            // Navigation buttons
            OnboardingNavigationWidget(
              currentPage: _currentPage,
              totalPages: _onboardingData.length,
              onSkip: _skipOnboarding,
              onNext: _nextPage,
              onGetStarted: _completeOnboarding,
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
