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

  // Mock data for selected components
  final List<Map<String, dynamic>> _selectedComponents = [
    {
      "id": 1,
      "name": "Arduino Uno",
      "category": "Microcontroller",
      "categoryIcon": "memory",
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
      "categoryIcon": "settings",
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

  // Mock data for filter categories
  final List<Map<String, dynamic>> _filterCategories = [
    {"label": "All", "icon": "apps", "isSelected": true},
    {
      "label": "Electronics",
      "icon": "electrical_services",
      "isSelected": false
    },
    {"label": "Sensors", "icon": "sensors", "isSelected": false},
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
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice search activated')),
    );
  }

  void _handleFilterTap() {
    // Advanced filter functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Advanced filters opened')),
    );
  }

  void _handleScanQRCode() {
    // QR/Barcode scanning functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening camera for QR/Barcode scanning')),
    );
  }

  void _handleBrowseComponents() {
    Navigator.pushNamed(context, '/component-database-browser');
  }

  void _handleManualEntry() {
    // Manual component entry functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening manual component entry')),
    );
  }

  void _handleGenerateIdeas() {
    if (_selectedComponents.length >= 3) {
      Navigator.pushNamed(context, '/ai-idea-generation');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please select at least 3 components to generate ideas')),
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
          'ATAL Idea Generator',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          indicatorWeight: 2,
          labelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Components'),
            Tab(text: 'Generate'),
            Tab(text: 'Library'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Components Tab
          _buildComponentsTab(),
          // Generate Tab
          _buildGenerateTab(),
          // Library Tab
          _buildLibraryTab(),
          // Profile Tab
          _buildProfileTab(),
        ],
      ),
      floatingActionButton: _selectedComponents.length >= 3
          ? FloatingActionButton.extended(
              onPressed: _handleGenerateIdeas,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
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
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              hintText: 'Search components...',
              onMicrophoneTap: _handleVoiceSearch,
              onFilterTap: _handleFilterTap,
              onChanged: (value) {
                // Handle search input
              },
            ),
            SizedBox(height: 3.h),

            // Filter Chips
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
            SizedBox(height: 3.h),

            // Action Cards
            Text(
              'Add Components',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Scan QR/Barcode',
              description: 'Use camera to scan component codes',
              iconName: 'qr_code_scanner',
              onTap: _handleScanQRCode,
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Browse Components',
              description: 'Search from component database',
              iconName: 'grid_view',
              onTap: _handleBrowseComponents,
            ),
            SizedBox(height: 2.h),

            ActionCardWidget(
              title: 'Manual Entry',
              description: 'Add components manually with autocomplete',
              iconName: 'add_circle_outline',
              onTap: _handleManualEntry,
            ),
            SizedBox(height: 4.h),

            // Selected Components Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Selected Components',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_selectedComponents.length} items',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Selected Components List
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
                    height: 8.h,
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
            SizedBox(height: 2.h),

            if (_selectedComponents.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _selectedComponents.length >= 3
                          ? 'Ready to Generate Ideas!'
                          : 'Add ${3 - _selectedComponents.length} more components',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
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
        actionText: 'Explore Library',
        onActionTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Library feature coming soon')),
          );
        },
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: EmptyStateWidget(
        title: 'User Profile',
        description:
            'Manage your account settings, preferences, and project history.',
        iconName: 'person',
        actionText: 'View Profile',
        onActionTap: () => Navigator.pushNamed(context, '/user-profile'),
      ),
    );
  }
}
