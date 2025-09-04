import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/additional_preferences_section.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/skill_level_selector.dart';
import './widgets/theme_selection_card.dart';

class ThemeAndSkillSelection extends StatefulWidget {
  const ThemeAndSkillSelection({super.key});

  @override
  State<ThemeAndSkillSelection> createState() => _ThemeAndSkillSelectionState();
}

class _ThemeAndSkillSelectionState extends State<ThemeAndSkillSelection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Selection state
  final Set<String> _selectedThemes = {};
  SkillLevel? _selectedSkillLevel;
  String? _selectedDuration;
  String? _selectedTeamSize;
  final List<String> _selectedInterests = [];

  // Loading state
  bool _isGenerating = false;

  // Theme data
  final List<Map<String, dynamic>> _themes = [
    {
      'title': 'Robotics',
      'icon': 'smart_toy',
      'description': 'Build autonomous robots and mechanical systems',
    },
    {
      'title': 'Environment',
      'icon': 'eco',
      'description': 'Create solutions for environmental challenges',
    },
    {
      'title': 'Health',
      'icon': 'favorite',
      'description': 'Develop healthcare and wellness technologies',
    },
    {
      'title': 'Agriculture',
      'icon': 'agriculture',
      'description': 'Innovate farming and food production methods',
    },
    {
      'title': 'Smart City',
      'icon': 'location_city',
      'description': 'Design urban technology solutions',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPreviousSelections();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  void _loadPreviousSelections() {
    // In a real app, this would load from SharedPreferences
    // For now, we'll leave it empty to demonstrate fresh selection
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _canGenerateIdeas {
    return _selectedThemes.isNotEmpty && _selectedSkillLevel != null;
  }

  void _onThemeSelected(String theme) {
    setState(() {
      if (_selectedThemes.contains(theme)) {
        _selectedThemes.remove(theme);
      } else {
        _selectedThemes.add(theme);
      }
    });
  }

  void _onSkillLevelChanged(SkillLevel level) {
    setState(() {
      _selectedSkillLevel = level;
    });
  }

  void _onDurationChanged(String duration) {
    setState(() {
      _selectedDuration = duration;
    });
  }

  void _onTeamSizeChanged(String teamSize) {
    setState(() {
      _selectedTeamSize = teamSize;
    });
  }

  void _onInterestsChanged(List<String> interests) {
    setState(() {
      _selectedInterests.clear();
      _selectedInterests.addAll(interests);
    });
  }

  Future<void> _generateIdeas() async {
    if (!_canGenerateIdeas) return;

    setState(() {
      _isGenerating = true;
    });

    // Simulate AI processing time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isGenerating = false;
      });

      // Navigate to AI idea generation screen with selected preferences
      Navigator.pushNamed(
        context,
        '/ai-idea-generation',
        arguments: {
          'themes': _selectedThemes.toList(),
          'skillLevel': _selectedSkillLevel.toString().split('.').last,
          'duration': _selectedDuration,
          'teamSize': _selectedTeamSize,
          'interests': _selectedInterests,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Theme & Skill Selection',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/user-profile'),
            icon: CustomIconWidget(
              iconName: 'person',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Progress Indicator
              const ProgressIndicatorWidget(
                currentStep: 2,
                totalSteps: 3,
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Theme Selection Section
                      _buildThemeSelectionSection(context),

                      SizedBox(height: 4.h),

                      // Skill Level Section
                      SkillLevelSelector(
                        selectedLevel: _selectedSkillLevel,
                        onChanged: _onSkillLevelChanged,
                      ),

                      SizedBox(height: 4.h),

                      // Additional Preferences Section
                      AdditionalPreferencesSection(
                        selectedDuration: _selectedDuration,
                        selectedTeamSize: _selectedTeamSize,
                        selectedInterests: _selectedInterests,
                        onDurationChanged: _onDurationChanged,
                        onTeamSizeChanged: _onTeamSizeChanged,
                        onInterestsChanged: _onInterestsChanged,
                      ),

                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ),

              // Generate Ideas Button
              _buildGenerateButton(context),

              // Developed By Footer
              const DevelopedByFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelectionSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Project Themes',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Choose one or more themes that interest you. Multiple selections will give you more diverse project ideas.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 3.h),

        // Theme Cards Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.1,
          ),
          itemCount: _themes.length,
          itemBuilder: (context, index) {
            final theme = _themes[index];
            return ThemeSelectionCard(
              title: theme['title'] as String,
              iconName: theme['icon'] as String,
              isSelected: _selectedThemes.contains(theme['title']),
              onTap: () => _onThemeSelected(theme['title'] as String),
            );
          },
        ),

        if (_selectedThemes.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Selected: ${_selectedThemes.join(', ')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGenerateButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (!_canGenerateIdeas)
              Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: colorScheme.onErrorContainer,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Please select at least one theme and your skill level',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 7.h,
              child: ElevatedButton(
                onPressed:
                    _canGenerateIdeas && !_isGenerating ? _generateIdeas : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canGenerateIdeas
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: _canGenerateIdeas
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                  elevation: _canGenerateIdeas ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isGenerating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Generating Ideas...',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'auto_awesome',
                            color: _canGenerateIdeas
                                ? colorScheme.onPrimary
                                : colorScheme.onSurfaceVariant,
                            size: 6.w,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Generate Ideas',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: _canGenerateIdeas
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
