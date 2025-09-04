import 'package:flutter/material.dart';
import '../presentation/ai_idea_generation/ai_idea_generation.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/theme_and_skill_selection/theme_and_skill_selection.dart';
import '../presentation/component_selection_dashboard/component_selection_dashboard.dart';
import '../presentation/component_database_browser/component_database_browser.dart';
import '../presentation/ideas_library/ideas_library.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String aiIdeaGeneration = '/ai-idea-generation';
  static const String userProfile = '/user-profile';
  static const String onboardingFlow = '/onboarding-flow';
  static const String themeAndSkillSelection = '/theme-and-skill-selection';
  static const String componentSelectionDashboard =
      '/component-selection-dashboard';
  static const String componentDatabaseBrowser = '/component-database-browser';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    aiIdeaGeneration: (context) => const AiIdeaGeneration(),
    userProfile: (context) => const UserProfile(),
    onboardingFlow: (context) => const OnboardingFlow(),
    themeAndSkillSelection: (context) => const ThemeAndSkillSelection(),
    componentSelectionDashboard: (context) =>
        const ComponentSelectionDashboard(),
    componentDatabaseBrowser: (context) => const ComponentDatabaseBrowser(),
    // TODO: Add your other routes here
  };
}
