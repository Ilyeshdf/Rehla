import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/leaderboard_entry_model.dart';
import '../models/user_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  List<LeaderboardEntryModel> _entries = [];
  bool _isLoading = true;

  List<LeaderboardEntryModel> get entries => _entries;
  bool get isLoading => _isLoading;

  LeaderboardProvider() {
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/fake_users.json');
      final List<dynamic> decoded = jsonDecode(jsonString);
      _entries = decoded.map((e) => LeaderboardEntryModel.fromJson(e)).toList();
    } catch (e) {

      _entries = [
        LeaderboardEntryModel(rank: 1, userId: 'u1', username: 'Ahmed_Traveler', wilaya: 'Algiers', xp: 4500, placesUnlocked: 24, badge: 'Veteran'),
        LeaderboardEntryModel(rank: 2, userId: 'u2', username: 'Sara_Explores', wilaya: 'Bejaia', xp: 3800, placesUnlocked: 18, badge: 'Explorer'),
        LeaderboardEntryModel(rank: 3, userId: 'u3', username: 'Dahmane_G', wilaya: 'Oran', xp: 3200, placesUnlocked: 15, badge: 'Nomad'),
      ];
    }

    _isLoading = false;

    Future.microtask(() => notifyListeners());
  }

  void insertCurrentUser(UserModel user) {
    _entries.removeWhere((e) => e.userId == user.id);

    final entry = LeaderboardEntryModel(
      rank: 0,
      userId: user.id,
      username: user.username,
      wilaya: user.wilaya,
      xp: user.xp,
      placesUnlocked: user.unlockedAchievements.length,
      badge: user.level,
    );

    _entries.add(entry);
    _entries.sort((a, b) => b.xp.compareTo(a.xp));

    for (int i = 0; i < _entries.length; i++) {
        final old = _entries[i];
        _entries[i] = LeaderboardEntryModel(
          rank: i + 1,
          userId: old.userId,
          username: old.username,
          wilaya: old.wilaya,
          xp: old.xp,
          placesUnlocked: old.placesUnlocked,
          badge: old.badge,
        );
    }

    notifyListeners();
  }
}
