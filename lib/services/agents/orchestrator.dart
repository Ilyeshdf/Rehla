import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/itinerary_model.dart';
import 'agent_definitions.dart';

class AgentOrchestrator {
  final SafetyAgent _safetyAgent = SafetyAgent();
  final HeritageAgent _heritageAgent = HeritageAgent();
  final MarketplaceAgent _marketplaceAgent = MarketplaceAgent();

  Future<Itinerary> orchestratePlanning(String userRequest) async {
    // Stage 1: Parallel specialized processing
    final results = await Future.wait([
      _heritageAgent.process(userRequest),
      _safetyAgent.process(userRequest),
      _marketplaceAgent.process(userRequest),
    ]);

    final heritageData = results[0];
    final safetyData = results[1];
    final marketplaceData = results[2];

    // Stage 2: Synthesis Inference (The "Brain" that combines everything)
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
            'content': '''You are the Lead Orchestrator of Rihla. 
            Synthesize the following expert reports into a valid Itinerary JSON.
            
            HERITAGE EXPERT: $heritageData
            SAFETY EXPERT: $safetyData
            GEAR EXPERT: $marketplaceData
            
            SCHEMA REQUIREMENT:
            Return ONLY a JSON object following the Itinerary model:
            {
              "destination": "...",
              "days": [
                {
                  "day": 1,
                  "morning": {"place": "...", "activity": "...", "category": "...", "tip": "..."},
                  "afternoon": {...},
                  "evening": {...}
                }
              ]
            }
            Ensure the "tip" fields incorporate the safety and gear advice.''',
          },
          {
            'role': 'user',
            'content': 'Produce the final unified safe itinerary for: $userRequest',
          },
        ],
        'temperature': 0.3,
      }),
    );

    if (finalResponse.statusCode == 200) {
      final decoded = jsonDecode(finalResponse.body);
      final content = decoded['choices'][0]['message']['content'];
      
      // Extract and Parse JSON
      final jsonStr = _extractJson(content);
      return Itinerary.fromJson(jsonDecode(jsonStr));
    } else {
      throw Exception('Orchestration failed');
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
