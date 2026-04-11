import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/itinerary_model.dart';
import '../place_data_service.dart';
import 'agent_definitions.dart';

class AgentOrchestrator {
  final SafetyAgent _safetyAgent = SafetyAgent();
  final HeritageAgent _heritageAgent = HeritageAgent();
  final MarketplaceAgent _marketplaceAgent = MarketplaceAgent();

  Future<Itinerary> orchestratePlanning(String userRequest) async {
    // RAG SYSTEM: Fetch real places for the destinated wilaya if possible
    final allPlaces = await PlaceDataService.fetchAllPlaces();
    
    // Preliminary step: Identify the Wilaya from the request
    String? identifiedWilaya;
    final lowerRequest = userRequest.toLowerCase();
    if (lowerRequest.contains('بجاية') || lowerRequest.contains('bejaia')) identifiedWilaya = 'Bejaia';
    if (lowerRequest.contains('قسنطينة') || lowerRequest.contains('constantine')) identifiedWilaya = 'Constantine';
    if (lowerRequest.contains('جانت') || lowerRequest.contains('djanet')) identifiedWilaya = 'Djanet';
    if (lowerRequest.contains('عاصمة') || lowerRequest.contains('algiers')) identifiedWilaya = 'Algiers';
    
    final localPlaces = identifiedWilaya != null 
        ? allPlaces.where((p) => p.wilaya.toLowerCase() == identifiedWilaya!.toLowerCase()).toList()
        : allPlaces.sublist(0, allPlaces.length > 20 ? 20 : allPlaces.length);

    final placesJson = jsonEncode(localPlaces.map((p) => {
      'id': p.id,
      'name': p.name,
      'type': p.type,
      'description': p.description,
      'is_verified': p.isOfficial,
      'price': p.priceLabel,
    }).toList());

    final results = await Future.wait([
      _heritageAgent.process(userRequest),
      _safetyAgent.process(userRequest),
      _marketplaceAgent.process(userRequest),
    ]);

    final heritageData = results[0];
    final safetyData = results[1];
    final marketplaceData = results[2];

    final finalResponse = await http.post(
      Uri.parse(AppConstants.groqApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.groqApiKey}',
      },
      body: jsonEncode({
        'model': AppConstants.groqModel,
        'messages': [
          {
            'role': 'system',
            'content': '''You are Rihla, the Lead Orchestrator of the Mediterranean Horizon project, designed by architect Haddef Mohamed Ilyes (Powered by Grok/Groq).
            Your goal is to act as a "DATA SAVER" system by synthesizing expert reports and REAL PLACE DATA into a perfect itinerary.
            
            Real-world human knowledge is our winner card. Highlight the value of the climbing and hiking the user did as achievements.
            
            REAL PLACES DATABASE:
            $placesJson
            
            HERITAGE EXPERT REPORT: $heritageData
            SAFETY EXPERT REPORT: $safetyData
            GEAR EXPERT REPORT: $marketplaceData
            
            STRICT RULES:
            1. ONLY recommend places from the REAL PLACES DATABASE. Do not hallucinate.
            2. NEVER recommend "Hotel El Djazair" or "Hotel St George" - these are blacklisted.
            3. Synthesize safety and gear advice into the "tip" fields.
            4. If the user asked for hotels, PRIORITIZE "El Aurassi Hotel" and "Hotel Les Hammadites".
            5. Return ONLY a JSON object:
            {
              "destination": "...",
              "days": [
                {
                  "day": 1,
                  "morning": {"place": "...", "activity": "...", "category": "...", "tip": "...", "partner_id": "...", "place_id": "..."},
                  "afternoon": {"place": "...", "activity": "...", "category": "...", "tip": "...", "partner_id": "...", "place_id": "..."},
                  "evening": {"place": "...", "activity": "...", "category": "...", "tip": "...", "partner_id": "...", "place_id": "..."}
                }
              ]
            }
            ONLY use IDs from the REAL PLACES DATABASE. If a place has no ID or isn't in the database, use null.''',
          },
          {
            'role': 'user',
            'content': 'Produce the safe real-data itinerary for: $userRequest',
          },
        ],
        'temperature': 0.3,
      }),
    );

    if (finalResponse.statusCode == 200) {
      final decoded = jsonDecode(finalResponse.body);
      final content = decoded['choices'][0]['message']['content'];

      final jsonStr = _extractJson(content);
      return Itinerary.fromJson(jsonDecode(jsonStr));
    } else {
      throw Exception('Orchestration failed: ${finalResponse.body}');
    }
  }

  String _extractJson(String text) {
    final startIndex = text.indexOf('{');
    final endIndex = text.lastIndexOf('}');
    if (startIndex != -1 && endIndex != -1) {
      return text.substring(startIndex, endIndex + 1);
    }
    return text;
  }
}

