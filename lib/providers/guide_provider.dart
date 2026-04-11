import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/place_model.dart';

class GuideProvider extends ChangeNotifier {
  List<Guide> _guides = [];
  bool _isLoading = false;
  Guide? _selectedGuide;

  List<Guide> get guides => _guides;
  bool get isLoading => _isLoading;
  Guide? get selectedGuide => _selectedGuide;

  Future<void> loadGuides() async {
    if (_guides.isNotEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final String jsonString = await rootBundle.loadString('assets/data/guides.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _guides = jsonList.map((j) => Guide.fromJson(j)).toList();
    } catch (e) {
      debugPrint('Error loading guides: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Guide> getGuidesForWilaya(String wilaya) {
    return _guides.where((g) => g.wilaya?.toLowerCase() == wilaya.toLowerCase()).toList();
  }

  void selectGuide(Guide? guide) {
    _selectedGuide = guide;
    notifyListeners();
  }

  void clearSelection() {
    _selectedGuide = null;
    notifyListeners();
  }
}

