import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/developed_by_footer.dart';
import './widgets/idea_card_widget.dart';
import './widgets/search_filter_bar.dart';
import './widgets/library_stats_widget.dart';
import './widgets/idea_detail_modal.dart';

class IdeasLibrary extends StatefulWidget {
  const IdeasLibrary({super.key});

  @override
  State<IdeasLibrary> createState() => _IdeasLibraryState();
}

class _IdeasLibraryState extends State<IdeasLibrary>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  List<SavedIdea> _allIdeas = [];
  List<SavedIdea> _filteredIdeas = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = true;
  bool _showFavoritesOnly = false;

  final List<String> _filterOptions = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Robotics',
    'Environment',
    'Health',
    'Agriculture',
    'Smart City'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadIdeas();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadIdeas() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final ideas = await _databaseService.getSavedIdeas();
      setState(() {
        _allIdeas = ideas;
        _filteredIdeas = ideas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showSnackBar('Error loading ideas: $e');
    }
  }

  void _filterIdeas() {
    List<SavedIdea> filtered = _allIdeas;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((idea) {
        return idea.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            idea.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            idea.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'All') {
      filtered = filtered.where((idea) {
        if (['Beginner', 'Intermediate', 'Advanced'].contains(_selectedFilter)) {
          return idea.difficulty == _selectedFilter;
        } else {
          return idea.tags.contains(_selectedFilter) ||
              idea.components.any((component) => component.toLowerCase().contains(_selectedFilter.toLowerCase()));
        }
      }).toList();
    }

    // Apply favorites filter
    if (_showFavoritesOnly) {
      filtered = filtered.where((idea) => idea.isFavorite).toList();
    }

    setState(() {
      _filteredIdeas = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterIdeas();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterIdeas();
  }

  void _toggleFavoritesOnly() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
    });
    _filterIdeas();
  }

  Future<void> _toggleIdeaFavorite(String ideaId, bool isFavorite) async {
    try {
      await _databaseService.updateIdeaFavoriteStatus(ideaId, isFavorite);
      await _loadIdeas();
      _filterIdeas();
    } catch (e) {
      _showSnackBar('Error updating favorite: $e');
    }
  }

  Future<void> _deleteIdea(String ideaId) async {
    try {
      await _databaseService.deleteIdea(ideaId);
      await _loadIdeas();
      _filterIdeas();
      _showSnackBar('Idea deleted successfully');
    } catch (e) {
      _showSnackBar('Error deleting idea: $e');
    }
  }

  void _showIdeaDetails(SavedIdea idea) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IdeaDetailModal(
        idea: idea,
        onFavoriteToggle: (isFavorite) => _toggleIdeaFavorite(idea.id, isFavorite),
        onDelete: () => _deleteIdea(idea.id),
        onEdit: () => _editIdea(idea),
      ),
    );
  }

  void _editIdea(SavedIdea idea) {
    // This would open an edit idea screen
    _showSnackBar('Edit idea feature coming soon!');
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

  void _exportIdeas() {
    // Export functionality
    _showSnackBar('Export feature coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Ideas Library',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
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
            onPressed: _exportIdeas,
            icon: CustomIconWidget(
              iconName: 'file_download',
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'All Ideas'),
            Tab(text: 'Favorites'),
            Tab(text: 'Statistics'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          SearchFilterBar(
            controller: _searchController,
            onSearchChanged: _onSearchChanged,
            selectedFilter: _selectedFilter,
            filterOptions: _filterOptions,
            onFilterChanged: _onFilterChanged,
            showFavoritesOnly: _showFavoritesOnly,
            onToggleFavoritesOnly: _toggleFavoritesOnly,
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllIdeasTab(),
                _buildFavoritesTab(),
                _buildStatisticsTab(),
              ],
            ),
          ),

          // Developed By Footer
          const DevelopedByFooter(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/ai-idea-generation'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
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
      ),
    );
  }

  Widget _buildAllIdeasTab() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_filteredIdeas.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadIdeas,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 2.h,
          bottom: 12.h,
        ),
        itemCount: _filteredIdeas.length,
        itemBuilder: (context, index) {
          final idea = _filteredIdeas[index];
          return IdeaCardWidget(
            idea: idea,
            onTap: () => _showIdeaDetails(idea),
            onFavoriteToggle: (isFavorite) => _toggleIdeaFavorite(idea.id, isFavorite),
            onDelete: () => _deleteIdea(idea.id),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteIdeas = _filteredIdeas.where((idea) => idea.isFavorite).toList();

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (favoriteIdeas.isEmpty) {
      return _buildEmptyFavoritesState();
    }

    return RefreshIndicator(
      onRefresh: _loadIdeas,
      child: ListView.builder(
        padding: EdgeInsets.only(
          left: 4.w,
          right: 4.w,
          top: 2.h,
          bottom: 12.h,
        ),
        itemCount: favoriteIdeas.length,
        itemBuilder: (context, index) {
          final idea = favoriteIdeas[index];
          return IdeaCardWidget(
            idea: idea,
            onTap: () => _showIdeaDetails(idea),
            onFavoriteToggle: (isFavorite) => _toggleIdeaFavorite(idea.id, isFavorite),
            onDelete: () => _deleteIdea(idea.id),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 4.w,
        right: 4.w,
        top: 2.h,
        bottom: 12.h,
      ),
      child: LibraryStatsWidget(
        totalIdeas: _allIdeas.length,
        favoriteIdeas: _allIdeas.where((idea) => idea.isFavorite).length,
        ideasByDifficulty: {
          'Beginner': _allIdeas.where((idea) => idea.difficulty == 'Beginner').length,
          'Intermediate': _allIdeas.where((idea) => idea.difficulty == 'Intermediate').length,
          'Advanced': _allIdeas.where((idea) => idea.difficulty == 'Advanced').length,
        },
        mostUsedComponents: _getMostUsedComponents(),
        recentActivity: _getRecentActivity(),
      ),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading your ideas...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'library_books',
                color: colorScheme.primary,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No ideas found'
                  : 'Your Library is Empty',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Start generating and saving project ideas to build your personal library',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/ai-idea-generation'),
              icon: CustomIconWidget(
                iconName: 'auto_awesome',
                color: colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Generate Ideas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFavoritesState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'favorite_border',
                color: Colors.red,
                size: 10.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'No Favorite Ideas',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Mark ideas as favorites by tapping the heart icon to see them here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _getMostUsedComponents() {
    final Map<String, int> componentCount = {};
    for (final idea in _allIdeas) {
      for (final component in idea.components) {
        componentCount[component] = (componentCount[component] ?? 0) + 1;
      }
    }
    
    // Sort by count and return top 5
    final sortedEntries = componentCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Map.fromEntries(sortedEntries.take(5));
  }

  List<Map<String, dynamic>> _getRecentActivity() {
    final sortedIdeas = List<SavedIdea>.from(_allIdeas)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    return sortedIdeas.take(5).map((idea) => {
      'title': idea.title,
      'action': 'Saved',
      'date': idea.createdAt,
    }).toList();
  }
}