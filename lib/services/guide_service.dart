import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place_model.dart';

class GuideService {
  final _client = Supabase.instance.client;

  Future<List<Guide>> getAllGuides() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/guides.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((j) => Guide.fromJson(j)).toList();
    } catch (e) {
      try {
        final data = await _client.from('guides').select();
        return (data as List).map((e) => Guide.fromJson(e)).toList();
      } catch (err) {
        return [
          Guide(id: 'g1', name: 'يوسف أحمد (Youssef)', languages: ['Arabic', 'English'], rating: 4.9, phone: '0555123456', schedule: 'Available', basePrice: 2000, wilaya: 'Algiers', isVerified: true),
          Guide(id: 'g2', name: 'أمينة علي (Amina)', languages: ['Arabic', 'French'], rating: 4.8, phone: '0555123457', schedule: 'Weekends', basePrice: 2500, wilaya: 'Bejaia', isVerified: true),
          Guide(id: 'g3', name: 'طارق بن زياد (Tariq)', languages: ['Arabic', 'Spanish'], rating: 4.7, phone: '0555123458', schedule: 'Morning', basePrice: 1800, wilaya: 'Constantine', isVerified: true),
        ];
      }
    }
  }

  Future<List<Guide>> getGuidesByWilaya(String wilaya) async {
    final all = await getAllGuides();
    return all.where((g) => g.wilaya?.toLowerCase() == wilaya.toLowerCase()).toList();
  }
}

