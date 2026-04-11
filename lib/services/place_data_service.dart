import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/itinerary_model.dart';

class RemotePlace {
  final String id;
  final String name;
  final String wilaya;
  final double latitude;
  final double longitude;
  final String type;
  final String description;
  final double rating;
  final String img;
  final bool isOfficial;
  final String? phoneNumber;
  final List<Map<String, dynamic>>? prices;
  final dynamic schedule;

  RemotePlace({
    required this.id,
    required this.name,
    required this.wilaya,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.description,
    required this.rating,
    required this.img,
    this.isOfficial = false,
    this.phoneNumber,
    this.prices,
    this.schedule,
  });

  PlaceType get placeType {
    switch (type.toLowerCase()) {
      case 'hotel':
      case 'restaurant':
        return PlaceType.comfortable;
      case 'fun activities':
        return PlaceType.comfortable;
      case 'monument':
        return PlaceType.public;
      default:
        return PlaceType.public;
    }
  }

  bool get hasBooking => placeType == PlaceType.comfortable;

  String get priceLabel {
    if (prices != null && prices!.isNotEmpty) {
      final first = prices!.first;
      final amount = first['total_price_dzd'] ?? first['amount'];
      if (amount != null) return '${amount.toStringAsFixed(0)} DZD';
    }
    return 'Free';
  }

  factory RemotePlace.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] ?? {};
    return RemotePlace(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      wilaya: json['wilaya'] ?? '',
      latitude: (loc['Latitude'] ?? loc['latitude'] ?? 0.0).toDouble(),
      longitude: (loc['Longitude'] ?? loc['longitude'] ?? 0.0).toDouble(),
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      img: json['img'] ?? '',
      isOfficial: json['isOfficial'] ?? false,
      phoneNumber: json['phoneNumber'],
      prices: json['prices'] != null
          ? List<Map<String, dynamic>>.from(json['prices'])
          : (json['price'] != null
              ? List<Map<String, dynamic>>.from(json['price'])
              : null),
      schedule: json['schedule'],
    );
  }
}

class PlaceDataService {
  static List<RemotePlace>? _cache;
  static final _supabase = Supabase.instance.client;

  static Future<List<RemotePlace>> fetchAllPlaces() async {
    if (_cache != null) return _cache!;

    try {
      // Fetch from Supabase tables: places AND partners
      final results = await Future.wait([
        _supabase.from('places').select(),
        _supabase.from('partners').select(),
      ]);

      final placesData = results[0] as List;
      final partnersData = results[1] as List;

      final List<RemotePlace> combined = [];
      
      // Map places
      combined.addAll(placesData.map((e) => RemotePlace.fromJson(e)));
      
      // Map partners to RemotePlace format
      combined.addAll(partnersData.map((p) => RemotePlace(
        id: p['id'] ?? '',
        name: p['business_name'] ?? '',
        wilaya: p['wilaya'] ?? '',
        latitude: p['latitude']?.toDouble() ?? 0.0,
        longitude: p['longitude']?.toDouble() ?? 0.0,
        type: p['category'] ?? '',
        description: p['description'] ?? 'A verified Rihla partner property.',
        rating: 4.5,
        img: p['logo_url'] ?? 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80',
        isOfficial: p['verified'] ?? true,
        phoneNumber: p['phone'],
      )));

      if (combined.isNotEmpty) {
        _cache = combined;
        return combined;
      }
    } catch (e) {
      print('Supabase combined fetch error: $e');
    }

    // Fallback to local JSON
    try {
      final jsonString = await rootBundle.loadString('assets/data/repo_places.json');
      final List<dynamic> localData = jsonDecode(jsonString);
      _cache = localData.map((e) => RemotePlace.fromJson(e)).toList();
      return _cache!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<RemotePlace>> getPlacesByWilaya(String wilaya) async {
    final all = await fetchAllPlaces();
    return all
        .where((p) => p.wilaya.toLowerCase() == wilaya.toLowerCase())
        .toList();
  }

  static Future<List<RemotePlace>> getPlacesByType(String type) async {
    final all = await fetchAllPlaces();
    return all.where((p) => p.type.toLowerCase() == type.toLowerCase()).toList();
  }

  static Future<List<RemotePlace>> getBookablePlaces() async {
    final all = await fetchAllPlaces();
    return all.where((p) => p.hasBooking).toList();
  }

  static Future<List<String>> getAvailableWilayas() async {
    final all = await fetchAllPlaces();
    return all.map((p) => p.wilaya).toSet().toList();
  }

  static void clearCache() {
    _cache = null;
  }
}
