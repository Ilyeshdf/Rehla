import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place_model.dart';

class GuideService {
  final _client = Supabase.instance.client;

  Future<List<Guide>> getAllGuides() async {
    try {
      final data = await _client.from('guides').select();
      return (data as List).map((e) => Guide.fromJson(e)).toList();
    } catch (e) {
      // Mock data until Supabase is completely configured with rules
      return [
        Guide(id: 'g1', name: 'يوسف أحمد (Youssef)', languages: ['Arabic', 'English'], rating: 4.9, phone: '0555123456', schedule: 'Available', basePrice: 2000),
        Guide(id: 'g2', name: 'أمينة علي (Amina)', languages: ['Arabic', 'French'], rating: 4.8, phone: '0555123457', schedule: 'Weekends', basePrice: 2500),
        Guide(id: 'g3', name: 'طارق بن زياد (Tariq)', languages: ['Arabic', 'Spanish'], rating: 4.7, phone: '0555123458', schedule: 'Morning', basePrice: 1800),
      ];
    }
  }
}
