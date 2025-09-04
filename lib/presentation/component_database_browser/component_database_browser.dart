import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/component_category_card.dart';
import './widgets/component_detail_modal.dart';
import './widgets/component_item_card.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/search_bar_widget.dart';
import './widgets/selection_bottom_bar.dart';

class ComponentDatabaseBrowser extends StatefulWidget {
  const ComponentDatabaseBrowser({super.key});

  @override
  State<ComponentDatabaseBrowser> createState() =>
      _ComponentDatabaseBrowserState();
}

class _ComponentDatabaseBrowserState extends State<ComponentDatabaseBrowser> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _selectedCategory = 'All Categories';
  bool _isGridView = false;
  bool _isLoading = false;

  Map<String, dynamic> _filters = {
    'category': 'All Categories',
    'difficulty': 'All Levels',
    'projectType': 'All Projects',
    'costRange': const RangeValues(0, 5000),
    'availableOnly': false,
  };

  Set<String> _selectedComponents = <String>{};
  List<String> _recentSearches = ['Arduino', 'Sensor', 'LED', 'Motor'];

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'electronics',
      'name': 'Electronics',
      'icon': 'memory',
      'count': 45,
    },
    {
      'id': 'sensors',
      'name': 'Sensors',
      'icon': 'sensors',
      'count': 32,
    },
    {
      'id': 'motors',
      'name': 'Motors & Actuators',
      'icon': 'settings',
      'count': 18,
    },
    {
      'id': 'microcontrollers',
      'name': 'Microcontrollers',
      'icon': 'developer_board',
      'count': 12,
    },
    {
      'id': 'displays',
      'name': 'Displays',
      'icon': 'monitor',
      'count': 15,
    },
    {
      'id': 'power',
      'name': 'Power Supply',
      'icon': 'battery_charging_full',
      'count': 22,
    },
    {
      'id': 'connectivity',
      'name': 'Connectivity',
      'icon': 'wifi',
      'count': 28,
    },
    {
      'id': 'mechanical',
      'name': 'Mechanical',
      'icon': 'build',
      'count': 35,
    },
  ];

  final List<Map<String, dynamic>> _components = [
    {
      'id': 'arduino_uno',
      'name': 'Arduino Uno R3',
      'category': 'microcontrollers',
      'description':
          'Popular microcontroller board based on ATmega328P chip, perfect for beginners and prototyping projects.',
      'image':
          'https://images.unsplash.com/photo-1553406830-ef2513450d76?w=400&h=300&fit=crop',
      'available': true,
      'cost': 850,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Microcontroller', 'value': 'ATmega328P'},
        {'label': 'Operating Voltage', 'value': '5V'},
        {'label': 'Digital I/O Pins', 'value': '14'},
        {'label': 'Analog Input Pins', 'value': '6'},
        {'label': 'Flash Memory', 'value': '32KB'},
      ],
      'compatibleProjects': ['Robotics', 'IoT', 'Automation', 'Environmental'],
    },
    {
      'id': 'ultrasonic_sensor',
      'name': 'HC-SR04 Ultrasonic Sensor',
      'category': 'sensors',
      'description':
          'Distance measuring sensor using ultrasonic waves, commonly used in robotics and automation projects.',
      'image':
          'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=300&fit=crop',
      'available': true,
      'cost': 120,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Operating Voltage', 'value': '5V DC'},
        {'label': 'Operating Current', 'value': '15mA'},
        {'label': 'Measuring Range', 'value': '2cm - 400cm'},
        {'label': 'Accuracy', 'value': '3mm'},
        {'label': 'Measuring Angle', 'value': '15°'},
      ],
      'compatibleProjects': ['Robotics', 'Smart City', 'Automation'],
    },
    {
      'id': 'servo_motor',
      'name': 'SG90 Micro Servo Motor',
      'category': 'motors',
      'description':
          'Small and lightweight servo motor with precise control, ideal for robotic arms and steering mechanisms.',
      'image':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
      'available': true,
      'cost': 180,
      'difficulty': 'Intermediate',
      'specifications': [
        {'label': 'Operating Voltage', 'value': '4.8V - 6V'},
        {'label': 'Stall Torque', 'value': '1.8 kg/cm'},
        {'label': 'Operating Speed', 'value': '0.1s/60°'},
        {'label': 'Rotation Range', 'value': '180°'},
        {'label': 'Weight', 'value': '9g'},
      ],
      'compatibleProjects': ['Robotics', 'Automation', 'Smart City'],
    },
    {
      'id': 'led_strip',
      'name': 'WS2812B LED Strip',
      'category': 'electronics',
      'description':
          'Addressable RGB LED strip with individual pixel control, perfect for lighting effects and displays.',
      'image':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=300&fit=crop',
      'available': false,
      'cost': 450,
      'difficulty': 'Intermediate',
      'specifications': [
        {'label': 'Operating Voltage', 'value': '5V DC'},
        {'label': 'Power Consumption', 'value': '60mA per LED'},
        {'label': 'LEDs per Meter', 'value': '60'},
        {'label': 'Color Depth', 'value': '24-bit'},
        {'label': 'Protocol', 'value': 'Single Wire'},
      ],
      'compatibleProjects': ['IoT', 'Smart City', 'Environmental'],
    },
    {
      'id': 'temperature_sensor',
      'name': 'DHT22 Temperature & Humidity Sensor',
      'category': 'sensors',
      'description':
          'Digital sensor for measuring temperature and humidity with high accuracy and reliability.',
      'image':
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400&h=300&fit=crop',
      'available': true,
      'cost': 280,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Operating Voltage', 'value': '3.3V - 6V'},
        {'label': 'Temperature Range', 'value': '-40°C to 80°C'},
        {'label': 'Humidity Range', 'value': '0% to 100% RH'},
        {'label': 'Temperature Accuracy', 'value': '±0.5°C'},
        {'label': 'Humidity Accuracy', 'value': '±2% RH'},
      ],
      'compatibleProjects': ['Environmental', 'IoT', 'Health Tech'],
    },
    {
      'id': 'lcd_display',
      'name': '16x2 LCD Display',
      'category': 'displays',
      'description':
          'Character LCD display with 16 columns and 2 rows, commonly used for displaying sensor data and messages.',
      'image':
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop',
      'available': true,
      'cost': 320,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Display Size', 'value': '16x2 characters'},
        {'label': 'Operating Voltage', 'value': '5V'},
        {'label': 'Backlight', 'value': 'Blue with white text'},
        {'label': 'Interface', 'value': 'Parallel (4-bit/8-bit)'},
        {'label': 'Controller', 'value': 'HD44780'},
      ],
      'compatibleProjects': ['Robotics', 'IoT', 'Automation', 'Environmental'],
    },
    {
      'id': 'breadboard',
      'name': 'Half-Size Breadboard',
      'category': 'electronics',
      'description':
          'Solderless breadboard for prototyping electronic circuits, essential for any electronics project.',
      'image':
          'https://images.unsplash.com/photo-1581092160562-40aa08e78837?w=400&h=300&fit=crop',
      'available': true,
      'cost': 150,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Tie Points', 'value': '400'},
        {'label': 'Size', 'value': '82.5mm x 55mm'},
        {'label': 'Material', 'value': 'ABS Plastic'},
        {'label': 'Contact Rating', 'value': '1A @ 5V DC'},
        {'label': 'Color', 'value': 'White'},
      ],
      'compatibleProjects': [
        'Robotics',
        'IoT',
        'Automation',
        'Environmental',
        'Health Tech'
      ],
    },
    {
      'id': 'jumper_wires',
      'name': 'Jumper Wire Set (M-M, M-F, F-F)',
      'category': 'electronics',
      'description':
          'Set of 120 jumper wires in different configurations for connecting components on breadboards.',
      'image':
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=400&h=300&fit=crop',
      'available': true,
      'cost': 200,
      'difficulty': 'Beginner',
      'specifications': [
        {'label': 'Wire Length', 'value': '20cm'},
        {'label': 'Wire Gauge', 'value': '26 AWG'},
        {'label': 'Connector Type', 'value': 'Dupont'},
        {'label': 'Quantity', 'value': '120 pieces'},
        {'label': 'Colors', 'value': 'Assorted'},
      ],
      'compatibleProjects': [
        'Robotics',
        'IoT',
        'Automation',
        'Environmental',
        'Health Tech',
        'Smart City'
      ],
    },
  ];

  List<Map<String, dynamic>> get _filteredComponents {
    List<Map<String, dynamic>> filtered = _components;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((component) {
        final name = (component['name'] as String).toLowerCase();
        final description = (component['description'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || description.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All Categories') {
      final categoryId = _categories
          .firstWhere((cat) => cat['name'] == _selectedCategory)['id'];
      filtered = filtered
          .where((component) => component['category'] == categoryId)
          .toList();
    }

    // Apply other filters
    if (_filters['availableOnly'] as bool) {
      filtered = filtered
          .where((component) => component['available'] as bool)
          .toList();
    }

    final costRange = _filters['costRange'] as RangeValues;
    filtered = filtered.where((component) {
      final cost = component['cost'] as int;
      return cost >= costRange.start && cost <= costRange.end;
    }).toList();

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreComponents();
    }
  }

  Future<void> _loadMoreComponents() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more components
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshComponents() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    if (query.isNotEmpty && !_recentSearches.contains(query)) {
      setState(() {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
      });
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _filters,
        onFiltersChanged: (filters) {
          setState(() {
            _filters = filters;
            _selectedCategory = filters['category'] as String;
          });
        },
      ),
    );
  }

  void _onVoiceSearch() {
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    setState(() {
      _selectedCategory = category['name'] as String;
      _isGridView = true;
    });
  }

  void _toggleComponentSelection(String componentId) {
    setState(() {
      if (_selectedComponents.contains(componentId)) {
        _selectedComponents.remove(componentId);
      } else {
        _selectedComponents.add(componentId);
      }
    });
  }

  void _showComponentDetail(Map<String, dynamic> component) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ComponentDetailModal(
        component: component,
        isSelected: _selectedComponents.contains(component['id']),
        onAddToSelection: () {
          _toggleComponentSelection(component['id'] as String);
          Navigator.pop(context);
        },
        onViewTutorials: () {
          Navigator.pop(context);
          // Navigate to tutorials
        },
      ),
    );
  }

  void _onViewSelection() {
    // Navigate to selection view
    Navigator.pushNamed(context, '/component-selection-dashboard');
  }

  void _clearSelection() {
    setState(() {
      _selectedComponents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Component Database',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: CustomIconWidget(
              iconName: _isGridView ? 'view_list' : 'grid_view',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
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
      body: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onChanged: _onSearchChanged,
            onFilterTap: _showFilterBottomSheet,
            onVoiceSearch: _onVoiceSearch,
            hintText: 'Search components...',
          ),
          Expanded(
            child: _buildMainContent(),
          ),
          const DevelopedByFooter(),
        ],
      ),
      bottomNavigationBar: null, // Remove the old bottom navigation bar since we have the footer
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        if (_searchQuery.isEmpty && !_isGridView) ...[
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshComponents,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 5.h),
                itemCount: _categories.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _categories.length) {
                    return Container(
                      padding: EdgeInsets.all(4.w),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final category = _categories[index];
                  return ComponentCategoryCard(
                    category: category,
                    onTap: () => _onCategoryTap(category),
                  );
                },
              ),
            ),
          ),
        ] else ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                if (_isGridView)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _isGridView = false;
                        _selectedCategory = 'All Categories';
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Theme.of(context).colorScheme.primary,
                      size: 4.w,
                    ),
                    label: Text(
                      'Back to Categories',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  '${_filteredComponents.length} components found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshComponents,
              child: _filteredComponents.isEmpty
                  ? _buildEmptyState(Theme.of(context), Theme.of(context).colorScheme)
                  : GridView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.only(
                        left: 2.w,
                        right: 2.w,
                        bottom: 5.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                      ),
                      itemCount:
                          _filteredComponents.length + (_isLoading ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _filteredComponents.length) {
                          return Container(
                            margin: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final component = _filteredComponents[index];
                        return ComponentItemCard(
                          component: component,
                          isSelected:
                              _selectedComponents.contains(component['id']),
                          onAddToSelection: () => _toggleComponentSelection(
                              component['id'] as String),
                          onLearnMore: () => _showComponentDetail(component),
                        );
                      },
                    ),
            ),
          ),
        ],
        if (_selectedComponents.isNotEmpty)
          SelectionBottomBar(
            selectedCount: _selectedComponents.length,
            onViewSelection: _onViewSelection,
            onClearSelection: _clearSelection,
          ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              'No components found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: Text(
                    'Clear Search',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                TextButton(
                  onPressed: () {
                    // Request component functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Component request feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text(
                    'Request Component',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
