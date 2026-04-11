import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PartnerProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  
  int _totalBookings = 0;
  int _weeklyViews = 124;
  double _rating = 4.8;
  double _conversionRate = 18.5;

  int get totalBookings => _totalBookings;
  int get weeklyViews => _weeklyViews;
  double get rating => _rating;
  double get conversionRate => _conversionRate;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> get bookings => _bookings;

  PartnerProvider() {
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabase
          .from('bookings')
          .select()
          .order('date', ascending: false);
      
      _bookings = (data as List).map((b) => {
        'id': b['id'],
        'name': b['notes']?.replaceFirst('Name: ', '') ?? 'Unknown',
        'phone': b['tourist_phone'] ?? '',
        'place_id': b['place_id'] ?? '',
        'date': b['date'] ?? '',
        'status': b['status'] ?? 'pending',
        'guests': b['party_size'] ?? 1,
      }).toList();
      
      _totalBookings = _bookings.length;
      
      final confirmed = _bookings.where((b) => b['status'] == 'confirmed').length;
      if (_totalBookings > 0) {
        _conversionRate = (confirmed / _totalBookings) * 100;
      }
    } catch (e) {
      debugPrint('Supabase Fetch Bookings Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBooking(Map<String, dynamic> booking) async {
    try {
      await _supabase.from('bookings').insert({
        'partner_id': booking['partner_id'],
        'place_id': booking['place_id'],
        'date': booking['date'],
        'party_size': booking['guests'],
        'notes': 'Name: ${booking['name']}',
        'tourist_phone': booking['phone'],
        'status': 'pending',
      });
      
      await fetchBookings();
    } catch (e) {
      debugPrint('Supabase Add Booking Error: $e');
      _bookings.insert(0, {
        'customer_name': booking['name'],
        'customer_phone': booking['phone'],
        'place_name': booking['place'],
        'booking_date': booking['date'],
        'status': 'pending',
        'number_of_guests': booking['guests'],
      });
      _totalBookings++;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(dynamic id, String status) async {
    try {
      await _supabase
          .from('bookings')
          .update({'status': status})
          .eq('id', id);
      
      await fetchBookings();
    } catch (_) {
      final idx = _bookings.indexWhere((b) => b['id'] == id);
      if (idx != -1) {
        _bookings[idx]['status'] = status;
        notifyListeners();
      }
    }
  }
}
