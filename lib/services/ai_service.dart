import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/itinerary_model.dart';
import 'agents/orchestrator.dart';

class AiService {
  static final AgentOrchestrator _orchestrator = AgentOrchestrator();

  static Future<Itinerary> generateItinerary({
    required String userPrompt,
    required int days,
  }) async {
    try {
      // Use the Multi-Agent Orchestrator for complex, multi-layered planning
      return await _orchestrator.orchestratePlanning(userPrompt);
    } catch (e) {
      // Any error, use fallback logic
      return await _loadFallbackItinerary(days);
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
