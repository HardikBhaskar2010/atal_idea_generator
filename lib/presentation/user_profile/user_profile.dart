import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/subscription_card_widget.dart';
import './widgets/usage_stats_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _notificationsEnabled = true;
  bool _teacherSharingEnabled = false;
  bool _darkModeEnabled = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Arjun Sharma",
    "email": "arjun.sharma@student.edu",
    "avatar":
        "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
    "institution": "Delhi Public School - ATAL Lab",
    "tier": "Free",
    "grade": "Class 10",
    "joinDate": "September 2024",
  };

  final Map<String, dynamic> statsData = {
    "ideasGenerated": 23,
    "projectsCompleted": 5,
    "componentsScanned": 47,
    "daysActive": 18,
  };

  final Map<String, dynamic> subscriptionData = {
    "tier": "Free",
    "ideasUsed": 23,
    "ideasLimit": 50,
    "projectsSaved": 5,
    "projectsLimit": 10,
    "nextBilling": null,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleSettingsTap(String key) {
    switch (key) {
      case 'edit_profile':
        _showEditProfileDialog();
        break;
      case 'change_password':
        _showChangePasswordDialog();
        break;
      case 'notifications_toggle':
        setState(() {
          _notificationsEnabled = !_notificationsEnabled;
        });
        _showSnackBar(
            'Notifications ${_notificationsEnabled ? 'enabled' : 'disabled'}');
        break;
      case 'theme_selection':
        _showThemeSelectionDialog();
        break;
      case 'skill_level':
        _showSkillLevelDialog();
        break;
      case 'project_duration':
        _showProjectDurationDialog();
        break;
      case 'atal_connection':
        _showATALConnectionDialog();
        break;
      case 'teacher_sharing_toggle':
        setState(() {
          _teacherSharingEnabled = !_teacherSharingEnabled;
        });
        _showSnackBar(
            'Teacher sharing ${_teacherSharingEnabled ? 'enabled' : 'disabled'}');
        break;
      case 'class_enrollment':
        _showClassEnrollmentDialog();
        break;
      case 'help_center':
        _navigateToHelp();
        break;
      case 'feedback':
        _showFeedbackDialog();
        break;
      case 'contact_support':
        _showContactSupportDialog();
        break;
      case 'export_data':
        _exportUserData();
        break;
      case 'delete_account':
        _showDeleteAccountDialog();
        break;
      default:
        _showSnackBar('Feature coming soon!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
              ),
              controller:
                  TextEditingController(text: userData["name"] as String),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Institution',
                hintText: 'Enter your school/institution',
              ),
              controller: TextEditingController(
                  text: userData["institution"] as String),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Profile updated successfully!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                hintText: 'Enter current password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            const TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter new password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 2.h),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm new password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Password changed successfully!');
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Selection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Light Theme'),
              value: 'light',
              groupValue: _darkModeEnabled ? 'dark' : 'light',
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = false;
                });
                Navigator.pop(context);
                _showSnackBar('Light theme selected');
              },
            ),
            RadioListTile<String>(
              title: const Text('Dark Theme'),
              value: 'dark',
              groupValue: _darkModeEnabled ? 'dark' : 'light',
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = true;
                });
                Navigator.pop(context);
                _showSnackBar('Dark theme selected');
              },
            ),
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('System theme selected');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillLevelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Skill Level'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Beginner'),
              subtitle: const Text('New to electronics and programming'),
              value: 'beginner',
              groupValue: 'intermediate',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Skill level set to Beginner');
              },
            ),
            RadioListTile<String>(
              title: const Text('Intermediate'),
              subtitle: const Text('Some experience with basic projects'),
              value: 'intermediate',
              groupValue: 'intermediate',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Skill level set to Intermediate');
              },
            ),
            RadioListTile<String>(
              title: const Text('Advanced'),
              subtitle: const Text('Experienced with complex projects'),
              value: 'advanced',
              groupValue: 'intermediate',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Skill level set to Advanced');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDurationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred Project Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('1-2 hours'),
              subtitle: const Text('Quick prototypes and experiments'),
              value: '1-2h',
              groupValue: '1-2h',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Project duration set to 1-2 hours');
              },
            ),
            RadioListTile<String>(
              title: const Text('Half day (3-4 hours)'),
              subtitle: const Text('Detailed projects with documentation'),
              value: '3-4h',
              groupValue: '1-2h',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Project duration set to half day');
              },
            ),
            RadioListTile<String>(
              title: const Text('Full day (6-8 hours)'),
              subtitle: const Text('Complex projects with multiple features'),
              value: '6-8h',
              groupValue: '1-2h',
              onChanged: (value) {
                Navigator.pop(context);
                _showSnackBar('Project duration set to full day');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showATALConnectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect to ATAL Lab'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Scan the QR code provided by your ATAL Lab coordinator to connect your account.'),
            SizedBox(height: 2.h),
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 15.w,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('QR scanner opened');
            },
            child: const Text('Scan QR Code'),
          ),
        ],
      ),
    );
  }

  void _showClassEnrollmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Class Enrollment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Class Code',
                hintText: 'Enter class code from teacher',
              ),
            ),
            SizedBox(height: 2.h),
            const Text(
              'Ask your teacher for the class enrollment code to join your class and share projects.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Enrollment request sent!');
            },
            child: const Text('Join Class'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'What is your feedback about?',
              ),
            ),
            SizedBox(height: 2.h),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Tell us what you think...',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Feedback sent successfully!');
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need help? Contact our support team:'),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'email',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                const Text('support@atalideas.edu.in'),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'phone',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                const Text('+91-11-2345-6789'),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                const Text('Mon-Fri, 9 AM - 6 PM'),
              ],
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Account deletion requested');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToHelp() {
    _showSnackBar('Opening help center...');
  }

  void _exportUserData() {
    _showSnackBar('Exporting user data...');
  }

  void _handleUpgrade() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Pro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose your subscription plan:'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Plan - ₹99/month',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  const Text('• Unlimited idea generation'),
                  const Text('• Advanced project templates'),
                  const Text('• Priority support'),
                  const Text('• Export to multiple formats'),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: Colors.amber,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Yearly Plan - ₹999/year',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          'Save 17%',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  const Text('• All monthly features'),
                  const Text('• Exclusive yearly content'),
                  const Text('• Early access to new features'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Redirecting to payment...');
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          ProfileHeaderWidget(userData: userData),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Stats'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildStatsTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final accountSettings = [
      {
        "key": "edit_profile",
        "title": "Edit Profile",
        "subtitle": "Update your personal information",
        "icon": "edit",
        "iconColor": Colors.blue,
        "type": "navigation",
      },
      {
        "key": "change_password",
        "title": "Change Password",
        "subtitle": "Update your account password",
        "icon": "lock",
        "iconColor": Colors.orange,
        "type": "navigation",
      },
      {
        "key": "notifications",
        "title": "Notifications",
        "subtitle": "Push notifications and alerts",
        "icon": "notifications",
        "iconColor": Colors.green,
        "type": "toggle",
        "value": _notificationsEnabled,
      },
    ];

    final educationalIntegration = [
      {
        "key": "atal_connection",
        "title": "ATAL Lab Connection",
        "subtitle": "Connect to your school's ATAL lab",
        "icon": "science",
        "iconColor": Colors.purple,
        "type": "navigation",
      },
      {
        "key": "teacher_sharing",
        "title": "Teacher Sharing",
        "subtitle": "Allow teachers to view your projects",
        "icon": "share",
        "iconColor": Colors.teal,
        "type": "toggle",
        "value": _teacherSharingEnabled,
      },
      {
        "key": "class_enrollment",
        "title": "Class Enrollment",
        "subtitle": "Join your class for collaborative projects",
        "icon": "group",
        "iconColor": Colors.indigo,
        "type": "navigation",
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          SubscriptionCardWidget(
            subscriptionData: subscriptionData,
            onUpgradeTap: _handleUpgrade,
          ),
          SizedBox(height: 2.h),
          SettingsSectionWidget(
            title: "Account Settings",
            items: accountSettings,
            onItemTap: _handleSettingsTap,
          ),
          SettingsSectionWidget(
            title: "Educational Integration",
            items: educationalIntegration,
            onItemTap: _handleSettingsTap,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          UsageStatsWidget(statsData: statsData),
          SizedBox(height: 2.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recent Achievements",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 2.h),
                _buildAchievementItem(
                  "First Project",
                  "Completed your first AI-generated project",
                  "trophy",
                  Colors.amber,
                ),
                _buildAchievementItem(
                  "Component Scanner",
                  "Scanned 25+ components using QR codes",
                  "qr_code_scanner",
                  Colors.blue,
                ),
                _buildAchievementItem(
                  "Idea Generator",
                  "Generated 20+ unique project ideas",
                  "lightbulb",
                  Colors.orange,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String description, String icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    final appPreferences = [
      {
        "key": "theme_selection",
        "title": "Theme Selection",
        "subtitle": "Choose your preferred app theme",
        "icon": "palette",
        "iconColor": Colors.purple,
        "type": "navigation",
      },
      {
        "key": "skill_level",
        "title": "Default Skill Level",
        "subtitle": "Set your default skill level for projects",
        "icon": "trending_up",
        "iconColor": Colors.green,
        "type": "navigation",
      },
      {
        "key": "project_duration",
        "title": "Preferred Project Duration",
        "subtitle": "Choose typical project completion time",
        "icon": "schedule",
        "iconColor": Colors.orange,
        "type": "navigation",
      },
    ];

    final supportOptions = [
      {
        "key": "help_center",
        "title": "Help Center",
        "subtitle": "FAQs and tutorials",
        "icon": "help",
        "iconColor": Colors.blue,
        "type": "navigation",
      },
      {
        "key": "feedback",
        "title": "Send Feedback",
        "subtitle": "Help us improve the app",
        "icon": "feedback",
        "iconColor": Colors.teal,
        "type": "navigation",
      },
      {
        "key": "contact_support",
        "title": "Contact Support",
        "subtitle": "Get help from our team",
        "icon": "support_agent",
        "iconColor": Colors.indigo,
        "type": "navigation",
      },
    ];

    final dataOptions = [
      {
        "key": "export_data",
        "title": "Export Data",
        "subtitle": "Download your projects and data",
        "icon": "download",
        "iconColor": Colors.green,
        "type": "navigation",
      },
      {
        "key": "delete_account",
        "title": "Delete Account",
        "subtitle": "Permanently remove your account",
        "icon": "delete_forever",
        "iconColor": Colors.red,
        "type": "navigation",
      },
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.h),
          SettingsSectionWidget(
            title: "App Preferences",
            items: appPreferences,
            onItemTap: _handleSettingsTap,
          ),
          SettingsSectionWidget(
            title: "Support Options",
            items: supportOptions,
            onItemTap: _handleSettingsTap,
          ),
          SettingsSectionWidget(
            title: "Data & Privacy",
            items: dataOptions,
            onItemTap: _handleSettingsTap,
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
