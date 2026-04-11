import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/itinerary_model.dart';
import 'agents/orchestrator.dart';
import 'place_data_service.dart';

class AiService {
  static final AgentOrchestrator _orchestrator = AgentOrchestrator();

  static Future<Itinerary> generateItinerary({
    required String userPrompt,
    required int days,
  }) async {
    try {

      return await _orchestrator.orchestratePlanning(userPrompt);
    } catch (e) {

      final realItinerary = await _buildFromRealData(days, userPrompt);
      if (realItinerary != null) return realItinerary;

      return await _loadFallbackItinerary(days);
    }
  }

  static Future<Itinerary?> _buildFromRealData(int days, String prompt) async {
    try {
      final allPlaces = await PlaceDataService.fetchAllPlaces();
      if (allPlaces.isEmpty) return null;

      String? targetWilaya;
      final promptLower = prompt.toLowerCase();

      if (promptLower.contains('قسنطينة') || promptLower.contains('constantine') || promptLower.contains('contantine')) {
        targetWilaya = 'Constantine';
      } else if (promptLower.contains('جانت') || promptLower.contains('djanet')) {
        targetWilaya = 'Djanet';
      } else if (promptLower.contains('بجاية') || promptLower.contains('bejaia')) {
        targetWilaya = 'Bejaia';
      } else if (promptLower.contains('عاصمة') || promptLower.contains('algiers')) {
        targetWilaya = 'Algiers';
      }

      final places = targetWilaya != null
          ? allPlaces.where((p) => p.wilaya.toLowerCase() == targetWilaya!.toLowerCase() || (targetWilaya == 'Constantine' && p.wilaya.toLowerCase() == 'contantine')).toList()
          : allPlaces;

      if (places.isEmpty) return null;

      final monuments = places.where((p) => p.type == 'monument').toList();
      final hotels = places.where((p) => p.type == 'hotel').toList();
      final restaurants = places.where((p) => p.type == 'restaurant').toList();
      final activities = places.where((p) => p.type == 'fun activities').toList();

      final generatedDays = List.generate(days, (i) {

        final morningPlace = monuments.isNotEmpty
            ? monuments[i % monuments.length]
            : places[i % places.length];

        final afternoonPlace = activities.isNotEmpty
            ? activities[i % activities.length]
            : (restaurants.isNotEmpty
                ? restaurants[i % restaurants.length]
                : places[(i + 1) % places.length]);

        final eveningPlace = hotels.isNotEmpty
            ? hotels[i % hotels.length]
            : (restaurants.isNotEmpty
                ? restaurants[i % restaurants.length]
                : places[(i + 2) % places.length]);

        return ItineraryDay(
          day: i + 1,
          morning: TimeSlot(
            place: morningPlace.name,
            activity: morningPlace.description,
            category: morningPlace.type,
            placeType: morningPlace.placeType,
          ),
          afternoon: TimeSlot(
            place: afternoonPlace.name,
            activity: afternoonPlace.description,
            category: afternoonPlace.type,
            placeType: afternoonPlace.placeType,
          ),
          evening: TimeSlot(
            place: eveningPlace.name,
            activity: eveningPlace.description,
            category: eveningPlace.type,
            tip: eveningPlace.priceLabel,
            placeType: eveningPlace.placeType,
          ),
        );
      });

      final destination = targetWilaya ?? places.first.wilaya;

      return Itinerary(
        destination: destination,
        days: generatedDays,
        wantsGuide: false,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<Itinerary> _loadFallbackItinerary(int days) async {
     try {
      final jsonString =
          await rootBundle.loadString('assets/data/fallback_itinerary.json');
      final json = jsonDecode(jsonString);
      final itinerary = Itinerary.fromJson(json);

      if (days <= itinerary.days.length) {
        return Itinerary(
          destination: itinerary.destination,
          days: itinerary.days.sublist(0, days),
          wantsGuide: false,
        );
      } else {
        final extendedDays = List<ItineraryDay>.from(itinerary.days);
        for (int i = itinerary.days.length; i < days; i++) {
          final sourceDay = itinerary.days[i % itinerary.days.length];
          extendedDays.add(ItineraryDay(
            day: i + 1,
            morning: sourceDay.morning,
            afternoon: sourceDay.afternoon,
            evening: sourceDay.evening,
          ));
        }
        return Itinerary(
          destination: itinerary.destination,
          days: extendedDays,
          wantsGuide: false,
        );
      }
    } catch (e) {
      return _generateMinimalItinerary(days);
    }
  }

  static Itinerary _generateMinimalItinerary(int days) {
    final generatedDays = List.generate(days, (i) {
      return ItineraryDay(
        day: i + 1,
        morning: TimeSlot(place: 'Algiers Casbah', activity: 'Safe guided historic walk', category: 'Heritage', placeType: PlaceType.public),
        afternoon: TimeSlot(place: 'Local Restaurant', activity: 'Traditional culinary experience', category: 'Food', placeType: PlaceType.comfortable),
        evening: TimeSlot(place: 'Verified Hotel Area', activity: 'Safe evening relaxation', tip: 'Verified zones only', placeType: PlaceType.comfortable),
      );
    });

    return Itinerary(
      destination: 'Algiers',
      days: generatedDays,
      wantsGuide: false,
    );
  }
}
