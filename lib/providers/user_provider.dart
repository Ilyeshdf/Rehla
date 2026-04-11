import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  List<AchievementModel> _allAchievements = [];
  bool _isLoading = true;

  UserModel? get currentUser => _currentUser;
  List<AchievementModel> get allAchievements => _allAchievements;
  bool get isLoading => _isLoading;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadAchievementsData();
    await _loadStoredUser();
    _isLoading = false;
    Future.microtask(() => notifyListeners());
  }

  Future<void> _loadAchievementsData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/achievements.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _allAchievements = jsonList.map((j) => AchievementModel.fromJson(j)).toList();
    } catch (e) {
      _allAchievements = [];
    }
  }

  Future<void> _loadStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      _currentUser = UserModel.fromJson(jsonDecode(userJson));

      for (var achId in _currentUser!.unlockedAchievements) {
        final idx = _allAchievements.indexWhere((a) => a.id == achId);
        if (idx != -1) {
          _allAchievements[idx].isUnlocked = true;
          _allAchievements[idx].unlockedAt = DateTime.now();
        }
      }
    } else {
      _currentUser = UserModel(
        id: 'u1',
        username: 'New_Explorer',
        wilaya: 'Algiers',
        level: 'Beginner',
        unlockedAchievements: [],
        firstDiscoveries: [],
      );
      await _saveUser();
    }
  }

  Future<void> _saveUser() async {
    if (_currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    notifyListeners();
  }

  Future<List<AchievementModel>> addXp(int amount) async {
    if (_currentUser == null) return [];

    final newXp = _currentUser!.xp + amount;
    String newLevel = _calculateLevel(newXp);

    _currentUser = _currentUser!.copyWith(
      xp: newXp,
      level: newLevel,
    );

    await _saveUser();
    return _checkAndUnlockAchievements();
  }

  Future<List<AchievementModel>> unlockPlace(String placeId) async {
    if (_currentUser == null) return [];

    if (!_currentUser!.firstDiscoveries.contains(placeId)) {
      final discoveries = List<String>.from(_currentUser!.firstDiscoveries)..add(placeId);
      _currentUser = _currentUser!.copyWith(firstDiscoveries: discoveries);
      await _saveUser();
    }

    return _checkAndUnlockAchievements();
  }

  String _calculateLevel(int xp) {
    if (xp <= 100) return 'Beginner';
    if (xp <= 300) return 'Traveler';
    if (xp <= 600) return 'Climber';
    if (xp <= 1000) return 'Adventurer';
    if (xp <= 2000) return 'Expert';
    return 'Legend 🔥';
  }

  Future<void> toggleGuideStatus() async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(isGuide: !_currentUser!.isGuide);
    await _saveUser();
  }

  Future<List<AchievementModel>> _checkAndUnlockAchievements() async {
    if (_currentUser == null) return [];
    List<AchievementModel> newlyUnlocked = [];

    if (_currentUser!.firstDiscoveries.length >= 5) {
      final achIdx = _allAchievements.indexWhere((a) => a.id == 'exp_2');
      if (achIdx != -1) {
        final ach = _allAchievements[achIdx];
        if (!ach.isUnlocked) {
          ach.isUnlocked = true;
          ach.unlockedAt = DateTime.now();
          final unlocked = List<String>.from(_currentUser!.unlockedAchievements)..add(ach.id);
          _currentUser = _currentUser!.copyWith(unlockedAchievements: unlocked);
          newlyUnlocked.add(ach);
        }
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      await _saveUser();
    }

    return newlyUnlocked;
  }
}
