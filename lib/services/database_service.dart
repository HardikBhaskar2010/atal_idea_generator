import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Data Models
class SavedIdea {
  final String id;
  final String title;
  final String description;
  final String problemStatement;
  final String workingPrinciple;
  final String difficulty;
  final String estimatedCost;
  final List<String> components;
  final List<String> innovationElements;
  final List<String> scalabilityOptions;
  final String availability;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final List<String> tags;
  final String notes;

  SavedIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.problemStatement,
    required this.workingPrinciple,
    required this.difficulty,
    required this.estimatedCost,
    required this.components,
    required this.innovationElements,
    required this.scalabilityOptions,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.tags = const [],
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'problemStatement': problemStatement,
      'workingPrinciple': workingPrinciple,
      'difficulty': difficulty,
      'estimatedCost': estimatedCost,
      'components': components,
      'innovationElements': innovationElements,
      'scalabilityOptions': scalabilityOptions,
      'availability': availability,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
      'tags': tags,
      'notes': notes,
    };
  }

  factory SavedIdea.fromJson(Map<String, dynamic> json) {
    return SavedIdea(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      problemStatement: json['problemStatement'] as String,
      workingPrinciple: json['workingPrinciple'] as String,
      difficulty: json['difficulty'] as String,
      estimatedCost: json['estimatedCost'] as String,
      components: List<String>.from(json['components'] as List),
      innovationElements: List<String>.from(json['innovationElements'] as List),
      scalabilityOptions: List<String>.from(json['scalabilityOptions'] as List),
      availability: json['availability'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
      notes: json['notes'] as String? ?? '',
    );
  }

  SavedIdea copyWith({
    String? id,
    String? title,
    String? description,
    String? problemStatement,
    String? workingPrinciple,
    String? difficulty,
    String? estimatedCost,
    List<String>? components,
    List<String>? innovationElements,
    List<String>? scalabilityOptions,
    String? availability,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    List<String>? tags,
    String? notes,
  }) {
    return SavedIdea(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      problemStatement: problemStatement ?? this.problemStatement,
      workingPrinciple: workingPrinciple ?? this.workingPrinciple,
      difficulty: difficulty ?? this.difficulty,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      components: components ?? this.components,
      innovationElements: innovationElements ?? this.innovationElements,
      scalabilityOptions: scalabilityOptions ?? this.scalabilityOptions,
      availability: availability ?? this.availability,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }
}

class UserPreferences {
  final List<String> selectedThemes;
  final String skillLevel;
  final String preferredDuration;
  final String teamSize;
  final List<String> interests;
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final DateTime lastUpdated;

  UserPreferences({
    this.selectedThemes = const [],
    this.skillLevel = 'Beginner',
    this.preferredDuration = '1-2 hours',
    this.teamSize = 'Individual',
    this.interests = const [],
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'selectedThemes': selectedThemes,
      'skillLevel': skillLevel,
      'preferredDuration': preferredDuration,
      'teamSize': teamSize,
      'interests': interests,
      'notificationsEnabled': notificationsEnabled,
      'darkModeEnabled': darkModeEnabled,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      selectedThemes: List<String>.from(json['selectedThemes'] as List? ?? []),
      skillLevel: json['skillLevel'] as String? ?? 'Beginner',
      preferredDuration: json['preferredDuration'] as String? ?? '1-2 hours',
      teamSize: json['teamSize'] as String? ?? 'Individual',
      interests: List<String>.from(json['interests'] as List? ?? []),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkModeEnabled: json['darkModeEnabled'] as bool? ?? false,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}

// Database Service
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String _savedIdeasKey = 'saved_ideas';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _componentsKey = 'selected_components';
  static const String _statsKey = 'user_stats';

  SharedPreferences? _prefs;

  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Saved Ideas Operations
  Future<List<SavedIdea>> getSavedIdeas() async {
    await initialize();
    final String? savedIdeasJson = _prefs?.getString(_savedIdeasKey);
    if (savedIdeasJson == null) return [];

    final List<dynamic> savedIdeasList = jsonDecode(savedIdeasJson);
    return savedIdeasList.map((json) => SavedIdea.fromJson(json)).toList();
  }

  Future<bool> saveIdea(SavedIdea idea) async {
    await initialize();
    try {
      final List<SavedIdea> currentIdeas = await getSavedIdeas();
      
      // Check if idea already exists
      final existingIndex = currentIdeas.indexWhere((i) => i.id == idea.id);
      if (existingIndex != -1) {
        // Update existing idea
        currentIdeas[existingIndex] = idea.copyWith(updatedAt: DateTime.now());
      } else {
        // Add new idea
        currentIdeas.add(idea);
      }

      final String savedIdeasJson = jsonEncode(
        currentIdeas.map((idea) => idea.toJson()).toList(),
      );
      
      return await _prefs?.setString(_savedIdeasKey, savedIdeasJson) ?? false;
    } catch (e) {
      print('Error saving idea: $e');
      return false;
    }
  }

  Future<bool> deleteIdea(String ideaId) async {
    await initialize();
    try {
      final List<SavedIdea> currentIdeas = await getSavedIdeas();
      currentIdeas.removeWhere((idea) => idea.id == ideaId);

      final String savedIdeasJson = jsonEncode(
        currentIdeas.map((idea) => idea.toJson()).toList(),
      );
      
      return await _prefs?.setString(_savedIdeasKey, savedIdeasJson) ?? false;
    } catch (e) {
      print('Error deleting idea: $e');
      return false;
    }
  }

  Future<bool> updateIdeaFavoriteStatus(String ideaId, bool isFavorite) async {
    await initialize();
    try {
      final List<SavedIdea> currentIdeas = await getSavedIdeas();
      final ideaIndex = currentIdeas.indexWhere((idea) => idea.id == ideaId);
      
      if (ideaIndex != -1) {
        currentIdeas[ideaIndex] = currentIdeas[ideaIndex].copyWith(
          isFavorite: isFavorite,
          updatedAt: DateTime.now(),
        );

        final String savedIdeasJson = jsonEncode(
          currentIdeas.map((idea) => idea.toJson()).toList(),
        );
        
        return await _prefs?.setString(_savedIdeasKey, savedIdeasJson) ?? false;
      }
      return false;
    } catch (e) {
      print('Error updating idea favorite status: $e');
      return false;
    }
  }

  Future<List<SavedIdea>> searchIdeas(String query) async {
    final List<SavedIdea> allIdeas = await getSavedIdeas();
    if (query.isEmpty) return allIdeas;

    final String lowerQuery = query.toLowerCase();
    return allIdeas.where((idea) {
      return idea.title.toLowerCase().contains(lowerQuery) ||
          idea.description.toLowerCase().contains(lowerQuery) ||
          idea.tags.any((tag) => tag.toLowerCase().contains(lowerQuery)) ||
          idea.components.any((component) => component.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<List<SavedIdea>> getIdeasByTag(String tag) async {
    final List<SavedIdea> allIdeas = await getSavedIdeas();
    return allIdeas.where((idea) => idea.tags.contains(tag)).toList();
  }

  Future<List<SavedIdea>> getFavoriteIdeas() async {
    final List<SavedIdea> allIdeas = await getSavedIdeas();
    return allIdeas.where((idea) => idea.isFavorite).toList();
  }

  // User Preferences Operations
  Future<UserPreferences> getUserPreferences() async {
    await initialize();
    final String? preferencesJson = _prefs?.getString(_userPreferencesKey);
    if (preferencesJson == null) {
      return UserPreferences(lastUpdated: DateTime.now());
    }

    return UserPreferences.fromJson(jsonDecode(preferencesJson));
  }

  Future<bool> saveUserPreferences(UserPreferences preferences) async {
    await initialize();
    try {
      final String preferencesJson = jsonEncode(preferences.toJson());
      return await _prefs?.setString(_userPreferencesKey, preferencesJson) ?? false;
    } catch (e) {
      print('Error saving user preferences: $e');
      return false;
    }
  }

  // Components Operations
  Future<List<Map<String, dynamic>>> getSelectedComponents() async {
    await initialize();
    final String? componentsJson = _prefs?.getString(_componentsKey);
    if (componentsJson == null) return [];

    final List<dynamic> componentsList = jsonDecode(componentsJson);
    return componentsList.cast<Map<String, dynamic>>();
  }

  Future<bool> saveSelectedComponents(List<Map<String, dynamic>> components) async {
    await initialize();
    try {
      final String componentsJson = jsonEncode(components);
      return await _prefs?.setString(_componentsKey, componentsJson) ?? false;
    } catch (e) {
      print('Error saving selected components: $e');
      return false;
    }
  }

  // Statistics Operations
  Future<Map<String, dynamic>> getUserStats() async {
    await initialize();
    final String? statsJson = _prefs?.getString(_statsKey);
    if (statsJson == null) {
      return {
        'ideasGenerated': 0,
        'projectsCompleted': 0,
        'componentsScanned': 0,
        'daysActive': 0,
        'lastActiveDate': DateTime.now().toIso8601String(),
      };
    }

    return jsonDecode(statsJson);
  }

  Future<bool> updateUserStats(Map<String, dynamic> stats) async {
    await initialize();
    try {
      final String statsJson = jsonEncode(stats);
      return await _prefs?.setString(_statsKey, statsJson) ?? false;
    } catch (e) {
      print('Error updating user stats: $e');
      return false;
    }
  }

  Future<bool> incrementStat(String statKey, {int increment = 1}) async {
    final Map<String, dynamic> currentStats = await getUserStats();
    currentStats[statKey] = (currentStats[statKey] as int? ?? 0) + increment;
    currentStats['lastActiveDate'] = DateTime.now().toIso8601String();
    return await updateUserStats(currentStats);
  }

  // Utility Operations
  Future<bool> clearAllData() async {
    await initialize();
    try {
      await _prefs?.remove(_savedIdeasKey);
      await _prefs?.remove(_userPreferencesKey);
      await _prefs?.remove(_componentsKey);
      await _prefs?.remove(_statsKey);
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> exportData() async {
    return {
      'savedIdeas': (await getSavedIdeas()).map((idea) => idea.toJson()).toList(),
      'userPreferences': (await getUserPreferences()).toJson(),
      'selectedComponents': await getSelectedComponents(),
      'userStats': await getUserStats(),
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  Future<bool> importData(Map<String, dynamic> data) async {
    await initialize();
    try {
      // Import saved ideas
      if (data['savedIdeas'] != null) {
        final List<SavedIdea> ideas = (data['savedIdeas'] as List)
            .map((json) => SavedIdea.fromJson(json))
            .toList();
        for (final idea in ideas) {
          await saveIdea(idea);
        }
      }

      // Import user preferences
      if (data['userPreferences'] != null) {
        final preferences = UserPreferences.fromJson(data['userPreferences']);
        await saveUserPreferences(preferences);
      }

      // Import selected components
      if (data['selectedComponents'] != null) {
        await saveSelectedComponents(
          List<Map<String, dynamic>>.from(data['selectedComponents']),
        );
      }

      // Import user stats
      if (data['userStats'] != null) {
        await updateUserStats(Map<String, dynamic>.from(data['userStats']));
      }

      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}