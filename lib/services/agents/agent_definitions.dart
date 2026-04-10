import 'base_agent.dart';

class SafetyAgent extends BaseAgent {
  SafetyAgent() : super(
    role: 'Safety & Security Officer',
    instructions: 'Your goal is to AUDIT travel plans for safety. identify risks in the Algerian landscape. Provide safety scores (0-5) and specific SOS guidance for destinations. Focus on verified routes and emergency contacts.'
  );
}

class HeritageAgent extends BaseAgent {
  HeritageAgent() : super(
    role: 'Cultural & History Specialist',
    instructions: 'Your goal is to enrich travel plans with Algerian heritage. Focus on historical landmarks (Casbah, Timgad), traditional food hotspots, and local customs in different Wilayas.'
  );
}

class MarketplaceAgent extends BaseAgent {
  MarketplaceAgent() : super(
    role: 'Gear & Logistics Expert',
    instructions: 'Your goal is to suggest relevant gear from the Rihla Marketplace. Based on the traveler type (individual, group, company), recommend specific equipment like tents, hiking boots, or professional guiding services.'
  );
}
