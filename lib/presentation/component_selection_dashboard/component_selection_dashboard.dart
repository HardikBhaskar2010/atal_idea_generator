import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_card_widget.dart';
import './widgets/component_chip_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_bar_widget.dart';

class ComponentSelectionDashboard extends StatefulWidget {
  const ComponentSelectionDashboard({super.key});

  @override
  State<ComponentSelectionDashboard> createState() =>
      _ComponentSelectionDashboardState();
}

class _ComponentSelectionDashboardState
    extends State<ComponentSelectionDashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  int _selectedFilterIndex = 0;
  bool _isRefreshing = false;

  // Mock data for selected components with enhanced icons
  final List<Map<String, dynamic>> _selectedComponents = [
    {
      "id": 1,
      "name": "Arduino Uno",
      "category": "Microcontroller",
      "categoryIcon": "developer_board",
      "quantity": 2,
    },
    {
      "id": 2,
      "name": "LED Strip",
      "category": "Electronics",
      "categoryIcon": "lightbulb",
      "quantity": 1,
    },
    {
      "id": 3,
      "name": "Servo Motor",
      "category": "Motors",
      "categoryIcon": "precision_manufacturing",
      "quantity": 3,
    },
    {
      "id": 4,
      "name": "Ultrasonic Sensor",
      "category": "Sensors",
      "categoryIcon": "sensors",
      "quantity": 1,
    },
  ];

  // Mock data for filter categories with enhanced icons
  final List<Map<String, dynamic>> _filterCategories = [
    {"label": "All", "icon": "dashboard", "isSelected": true},
    {
      "label": "Electronics",
      "icon": "electrical_services",
      "isSelected": false
    },
    {"label": "Sensors", "icon": "radar", "isSelected": false},
    {"label": "Motors", "icon": "settings", "isSelected": false},
    {"label": "Displays", "icon": "monitor", "isSelected": false},
    {"label": "Connectivity", "icon": "wifi", "isSelected": false},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  void _handleFilterSelection(int index) {
    setState(() {
      _selectedFilterIndex = index;
      for (int i = 0; i < _filterCategories.length; i++) {
        _filterCategories[i]["isSelected"] = i == index;
      }
    });
  }

  void _handleComponentRemove(int componentId) {
    setState(() {
      _selectedComponents
          .removeWhere((component) => (component["id"] as int) == componentId);
    });
  }

  void _handleQuantityChange(int componentId, bool increase) {
    setState(() {
      final componentIndex = _selectedComponents
          .indexWhere((component) => (component["id"] as int) == componentId);
      if (componentIndex != -1) {
        final currentQuantity =
            _selectedComponents[componentIndex]["quantity"] as int;
        if (increase) {
          _selectedComponents[componentIndex]["quantity"] = currentQuantity + 1;
        } else if (currentQuantity > 1) {
          _selectedComponents[componentIndex]["quantity"] = currentQuantity - 1;
        }
      }
    });
  }

  void _handleVoiceSearch() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'mic',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Voice search activated'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleFilterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'tune',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Advanced filters opened'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleScanQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'qr_code_scanner',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Opening camera for QR/Barcode scanning'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBrowseComponents() {
    Navigator.pushNamed(context, '/component-database-browser');
  }

  void _handleManualEntry() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'edit_note',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            const Text('Opening manual component entry'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleGenerateIdeas() {
    if (_selectedComponents.length >= 3) {
      Navigator.pushNamed(context, '/ai-idea-generation');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              const Text(
                  'Please select at least 3 components to generate ideas'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
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
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'science',
                color: colorScheme.primary,
                size: 6.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'ATAL Idea Generator',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications_active',
                        color: Colors.white,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      const Text('Notifications'),
                    ],
                  ),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: colorScheme.onSurface,
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          onTap: (index) {
            setState(() {
              // This will trigger a rebuild and update the icons
            });
          },
          tabs: const [
            Tab(
              icon: Icon(Icons.inventory_2),
              text: 'Components',
            ),
            Tab(
              icon: Icon(Icons.auto_awesome),
              text: 'Generate',
            ),
            Tab(
              icon: Icon(Icons.library_books),
              text: 'Library',
            ),
            Tab(
              icon: Icon(Icons.account_circle),
              text: 'Profile',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComponentsTab(),
          _buildGenerateTab(),
          _buildLibraryTab(),
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: _selectedComponents.length >= 3
          ? FloatingActionButton.extended(
              onPressed: _handleGenerateIdeas,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
              icon: CustomIconWidget(
                iconName: 'auto_awesome',
                color: colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Generate Ideas',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildComponentsTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Search Bar
            Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.05),
                    colorScheme.secondary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SearchBarWidget(
                controller: _searchController,
                hintText: 'Search components...',
                onMicrophoneTap: _handleVoiceSearch,
                onFilterTap: _handleFilterTap,
                onChanged: (value) {
                  // Handle search input
                },
              ),
            ),
            SizedBox(height: 3.h),

            // Enhanced Filter Chips
            SizedBox(
              height: 5.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filterCategories.length,
                itemBuilder: (context, index) {
                  final filter = _filterCategories[index];
                  return FilterChipWidget(
                    label: filter["label"] as String,
                    iconName: filter["icon"] as String,
                    isSelected: filter["isSelected"] as bool,
                    onTap: () => _handleFilterSelection(index),
                  );
                },
              ),
            ),
            SizedBox(height: 4.h),

            // Enhanced Action Cards Section
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'add_box',
                  color: colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Add Components',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Scan QR/Barcode',
              description: 'Use camera to scan component codes instantly',
              iconName: 'qr_code_scanner',
              onTap: _handleScanQRCode,
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Browse Components',
              description: 'Explore our comprehensive component database',
              iconName: 'search',
              onTap: _handleBrowseComponents,
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Manual Entry',
              description: 'Add components manually with smart autocomplete',
              iconName: 'edit_note',
              onTap: _handleManualEntry,
            ),
            SizedBox(height: 4.h),

            // Enhanced Selected Components Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'My Selected Components',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _selectedComponents.length >= 3
                          ? [
                              colorScheme.primary,
                              colorScheme.secondary,
                            ]
                          : [
                              colorScheme.onErrorContainer,
                              colorScheme.onErrorContainer,
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'inventory',
                        color: Colors.white,
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '${_selectedComponents.length} items',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Enhanced Selected Components List
            _selectedComponents.isEmpty
                ? EmptyStateWidget(
                    title: 'No Components Selected',
                    description:
                        'Start by adding components using the options above. You need at least 3 components to generate project ideas.',
                    iconName: 'inventory_2',
                    actionText: 'Browse Components',
                    onActionTap: _handleBrowseComponents,
                  )
                : SizedBox(
                    height: 12.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedComponents.length,
                      itemBuilder: (context, index) {
                        final component = _selectedComponents[index];
                        return ComponentChipWidget(
                          name: component["name"] as String,
                          category: component["category"] as String,
                          categoryIcon: component["categoryIcon"] as String,
                          quantity: component["quantity"] as int,
                          onRemove: () =>
                              _handleComponentRemove(component["id"] as int),
                          onQuantityIncrease: () => _handleQuantityChange(
                              component["id"] as int, true),
                          onQuantityDecrease: () => _handleQuantityChange(
                              component["id"] as int, false),
                        );
                      },
                    ),
                  ),
            SizedBox(height: 3.h),

            if (_selectedComponents.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _selectedComponents.length >= 3
                        ? [
                            colorScheme.primary.withValues(alpha: 0.1),
                            colorScheme.secondary.withValues(alpha: 0.1),
                          ]
                        : [
                            colorScheme.onErrorContainer.withValues(alpha: 0.1),
                            colorScheme.onErrorContainer.withValues(alpha: 0.05),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedComponents.length >= 3
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.onErrorContainer.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: _selectedComponents.length >= 3
                          ? 'lightbulb'
                          : 'warning',
                      color: _selectedComponents.length >= 3
                          ? colorScheme.primary
                          : colorScheme.onErrorContainer,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _selectedComponents.length >= 3
                          ? 'Ready to Generate Ideas!'
                          : 'Add ${3 - _selectedComponents.length} more components',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _selectedComponents.length >= 3
                            ? colorScheme.primary
                            : colorScheme.onErrorContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _selectedComponents.length >= 3
                          ? 'You have enough components to generate amazing project ideas'
                          : 'Select at least 3 components to unlock AI-powered project suggestions',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateTab() {
    return Center(
      child: EmptyStateWidget(
        title: 'AI Idea Generation',
        description:
            'Generate innovative project ideas based on your selected components and preferences.',
        iconName: 'auto_awesome',
        actionText: 'Go to Generation',
        onActionTap: () => Navigator.pushNamed(context, '/ai-idea-generation'),
      ),
    );
  }

  Widget _buildLibraryTab() {
    return Center(
      child: EmptyStateWidget(
        title: 'Your Idea Library',
        description:
            'Save and organize your favorite project ideas for future reference.',
        iconName: 'library_books',
        actionText: 'Open Library',
        onActionTap: () => Navigator.pushNamed(context, '/ideas-library'),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: EmptyStateWidget(
        title: 'User Profile',
        description:
            'Manage your account settings, preferences, and project history.',
        iconName: 'account_circle',
        actionText: 'View Profile',
        onActionTap: () => Navigator.pushNamed(context, '/user-profile'),
      ),
    );
  }
}