class PlaceData {
  final List<Wilaya> wilayas;

  PlaceData({required this.wilayas});

  factory PlaceData.fromJson(Map<String, dynamic> json) {
    return PlaceData(
      wilayas: (json['wilayas'] as List<dynamic>?)
              ?.map((w) => Wilaya.fromJson(w))
              .toList() ??
          [],
    );
  }

  Wilaya? getWilaya(String id) {
    try {
      return wilayas.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }
}

class Wilaya {
  final String id;
  final String name;
  final List<Hotel> hotels;
  final List<Restaurant> restaurants;
  final List<Site> sites;

  Wilaya({
    required this.id,
    required this.name,
    required this.hotels,
    required this.restaurants,
    required this.sites,
  });

  factory Wilaya.fromJson(Map<String, dynamic> json) {
    return Wilaya(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      hotels: (json['hotels'] as List<dynamic>?)
              ?.map((h) => Hotel.fromJson(h))
              .toList() ??
          [],
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((r) => Restaurant.fromJson(r))
              .toList() ??
          [],
      sites: (json['sites'] as List<dynamic>?)
              ?.map((s) => Site.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class Hotel {
  final String id;
  final String name;
  final int pricePerNight;
  final double rating;
  final List<String> amenities;
  final String image;

  Hotel({
    required this.id,
    required this.name,
    required this.pricePerNight,
    required this.rating,
    required this.amenities,
    required this.image,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      pricePerNight: json['price_per_night'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      amenities: List<String>.from(json['amenities'] ?? []),
      image: json['image'] ?? 'placeholder',
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final int avgPrice;
  final String hours;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.avgPrice,
    required this.hours,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cuisine: json['cuisine'] ?? '',
      avgPrice: json['avg_price'] ?? 0,
      hours: json['hours'] ?? '',
    );
  }
}

class Site {
  final String id;
  final String name;
  final String category;
  final int entryPrice;
  final String hours;
  final String tip;
  final bool hasBooking;
  final List<Guide> guides;
  final AiMetadata? metadata;

  Site({
    required this.id,
    required this.name,
    required this.category,
    required this.entryPrice,
    required this.hours,
    required this.tip,
    this.hasBooking = false,
    this.guides = const [],
    this.metadata,
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      entryPrice: json['entry_price'] ?? 0,
      hours: json['hours'] ?? '',
      tip: json['tip'] ?? '',
      hasBooking: json['has_booking'] ?? false,
      guides: (json['guides'] as List<dynamic>?)
              ?.map((g) => Guide.fromJson(g))
              .toList() ??
          [],
      metadata: json['metadata'] != null
          ? AiMetadata.fromJson(json['metadata'])
          : null,
    );
  }
}

class Guide {
  final String id;
  final String name;
  final List<String> languages;
  final double rating;
  final String phone;
  final String schedule;
  final int basePrice;
  final String? bio;
  final String? photoUrl;
  final int? reviewsCount;
  final List<String>? specialties;
  final String? wilaya;
  final bool isVerified;

  Guide({
    required this.id,
    required this.name,
    required this.languages,
    required this.rating,
    required this.phone,
    required this.schedule,
    required this.basePrice,
    this.bio,
    this.photoUrl,
    this.reviewsCount,
    this.specialties,
    this.wilaya,
    this.isVerified = false,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
      schedule: json['schedule'] ?? '',
      basePrice: json['base_price'] ?? 0,
      bio: json['bio'] ?? json['description'],
      photoUrl: json['photo_url'] ?? json['image_url'],
      reviewsCount: json['reviews_count'],
      specialties: json['specialties'] != null ? List<String>.from(json['specialties']) : null,
      wilaya: json['wilaya'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'languages': languages,
      'rating': rating,
      'phone': phone,
      'schedule': schedule,
      'base_price': basePrice,
      'bio': bio,
      'photo_url': photoUrl,
      'reviews_count': reviewsCount,
      'specialties': specialties,
      'wilaya': wilaya,
      'is_verified': isVerified,
    };
  }
}

class AiMetadata {
  final String budgetLevel;
  final String bestSeason;
  final int recommendedDurationMinutes;
  final String aiContext;

  AiMetadata({
    required this.budgetLevel,
    required this.bestSeason,
    required this.recommendedDurationMinutes,
    required this.aiContext,
  });

  factory AiMetadata.fromJson(Map<String, dynamic> json) {
    return AiMetadata(
      budgetLevel: json['budget_level'] ?? 'medium',
      bestSeason: json['best_season'] ?? 'year_round',
      recommendedDurationMinutes: json['recommended_duration_minutes'] ?? 120,
      aiContext: json['ai_context'] ?? '',
    );
  }
}
