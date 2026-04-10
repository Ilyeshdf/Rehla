/// Place type classification for the Rihla tourism system
/// - comfortable: Hotels, restaurants, paid services (BOOKABLE)
/// - public: Historical sites, mosques, parks (NOT BOOKABLE)
/// - wild: Mountains, Sahara, beaches, nature (TRACKABLE / START TRIP)
enum PlaceType { comfortable, public, wild }

class Itinerary {
  final String destination;
  final List<ItineraryDay> days;
  final bool wantsGuide;
  final String? selectedGuideId;

  Itinerary({
    required this.destination,
    required this.days,
    required this.wantsGuide,
    this.selectedGuideId,
  });

  /// Returns true if ANY place in the itinerary is wild (for START TRIP button)
  bool get hasWildPlaces {
    for (final day in days) {
      if (day.morning.placeType == PlaceType.wild ||
          day.afternoon.placeType == PlaceType.wild ||
          day.evening.placeType == PlaceType.wild) {
        return true;
      }
    }
    return false;
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      destination: json['destination'] ?? '',
      days: (json['days'] as List<dynamic>?)
              ?.map((d) => ItineraryDay.fromJson(d))
              .toList() ??
          [],
      wantsGuide: json['wants_guide'] ?? false,
      selectedGuideId: json['selected_guide_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'days': days.map((d) => d.toJson()).toList(),
      'wants_guide': wantsGuide,
      'selected_guide_id': selectedGuideId,
    };
  }
}

class ItineraryDay {
  final int day;
  final TimeSlot morning;
  final TimeSlot afternoon;
  final TimeSlot evening;

  ItineraryDay({
    required this.day,
    required this.morning,
    required this.afternoon,
    required this.evening,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) {
    return ItineraryDay(
      day: json['day'] ?? 1,
      morning: TimeSlot.fromJson(json['morning'] ?? {}),
      afternoon: TimeSlot.fromJson(json['afternoon'] ?? {}),
      evening: TimeSlot.fromJson(json['evening'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'morning': morning.toJson(),
      'afternoon': afternoon.toJson(),
      'evening': evening.toJson(),
    };
  }
}

class TimeSlot {
  final String place;
  final String activity;
  final String category;
  final String tip;
  final PlaceType placeType;

  /// Derived from placeType — only comfortable places can be booked
  bool get hasBooking => placeType == PlaceType.comfortable;

  /// Whether this place supports the "Start Trip" tracker
  bool get isTrackable => placeType == PlaceType.wild;

  TimeSlot({
    required this.place,
    required this.activity,
    this.category = '',
    this.tip = '',
    this.placeType = PlaceType.public,
  });

  /// Smart detection of place type from category keywords
  static PlaceType _detectPlaceType(String category, String place) {
    final catLower = category.toLowerCase();
    final placeLower = place.toLowerCase();

    // Comfortable = bookable services
    if (catLower.contains('أكل') || catLower.contains('food') ||
        catLower.contains('فندق') || catLower.contains('hotel') ||
        catLower.contains('مطعم') || catLower.contains('restaurant') ||
        placeLower.contains('فندق') || placeLower.contains('مطعم') ||
        placeLower.contains('hotel') || placeLower.contains('restaurant')) {
      return PlaceType.comfortable;
    }

    // Wild = nature, adventure, beaches
    if (catLower.contains('طبيعة') || catLower.contains('nature') ||
        catLower.contains('شاطئ') || catLower.contains('beach') ||
        catLower.contains('جبل') || catLower.contains('mountain') ||
        catLower.contains('صحراء') || catLower.contains('sahara') ||
        catLower.contains('مغامرة') || catLower.contains('adventure') ||
        placeLower.contains('شاطئ') || placeLower.contains('beach')) {
      return PlaceType.wild;
    }

    // Default = public (heritage, museums, mosques, parks, casbah)
    return PlaceType.public;
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final category = json['category'] ?? '';
    final place = json['place'] ?? '';

    // If place_type is explicitly set, use it; otherwise auto-detect
    PlaceType type;
    if (json['place_type'] != null) {
      switch (json['place_type']) {
        case 'comfortable':
          type = PlaceType.comfortable;
          break;
        case 'wild':
          type = PlaceType.wild;
          break;
        default:
          type = PlaceType.public;
      }
    } else {
      type = _detectPlaceType(category, place);
    }

    return TimeSlot(
      place: place,
      activity: json['activity'] ?? '',
      category: category,
      tip: json['tip'] ?? '',
      placeType: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place': place,
      'activity': activity,
      'category': category,
      'tip': tip,
      'place_type': placeType.name,
    };
  }
}
