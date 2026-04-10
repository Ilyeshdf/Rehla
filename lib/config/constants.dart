import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String groqApiKey = 'YOUR_GROQ_API_KEY_HERE';
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String groqModel = 'llama3-8b-8192';

  // Supabase Configuration
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // ── Mediterranean Horizon Dark Theme Colors ──
  static const Color backgroundDark = Color(0xFF0A0E1A);
  static const Color backgroundCard = Color(0xFF141825);
  static const Color backgroundElevated = Color(0xFF1C2133);
  static const Color surfaceDim = Color(0xFF0F1320);

  // Accent colors
  static const Color accentTeal = Color(0xFF4DD0E1);
  static const Color accentTealLight = Color(0xFF80DEEA);
  static const Color accentTealDark = Color(0xFF26C6DA);
  static const Color accentGold = Color(0xFFD4A04A);
  static const Color accentGoldLight = Color(0xFFE8C066);
  static const Color accentGoldDark = Color(0xFFBF8A30);
  static const Color accentAmber = Color(0xFFF9A825);

  // Legacy aliases
  static const Color primaryGreen = Color(0xFF4DD0E1);
  static const Color primaryGreenLight = Color(0xFF80DEEA);
  static const Color primaryGreenDark = Color(0xFF26C6DA);
  static const Color backgroundWhite = Color(0xFF0A0E1A);
  static const Color backgroundCream = Color(0xFF141825);

  // Status/Safety colors
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFCA28);
  static const Color liveRed = Color(0xFFFF4444);
  static const Color safetyGreen = Color(0xFF00E676);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A8B8);
  static const Color textTertiary = Color(0xFF6B7280);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textMedium = Color(0xFFA0A8B8);
  static const Color textLight = Color(0xFF6B7280);

  // Borders & Dividers
  static const Color divider = Color(0xFF2A2F42);
  static const Color borderSubtle = Color(0xFF1E2338);

  // Buyer Types
  static const List<Map<String, dynamic>> buyerTypes = [
    {'id': 'individual', 'label': 'Individual', 'ar': 'فردي', 'icon': Icons.person},
    {'id': 'group', 'label': 'Group', 'ar': 'مجموعة', 'icon': Icons.group},
    {'id': 'company', 'label': 'Company', 'ar': 'شركة', 'icon': Icons.business},
  ];

  // Store Mock Data
  static const List<Map<String, dynamic>> storeItems = [
    {
      'id': 'item1',
      'name': 'Pro Hiking Gear',
      'price': '4500 DA',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800&q=80',
      'seller': 'Decathlon DZ',
      'type': 'company',
      'rating': 4.8,
    },
    {
      'id': 'item2',
      'name': 'Desert Camping Tent',
      'price': '8200 DA',
      'image': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=800&q=80',
      'seller': 'Sahara Nomads',
      'type': 'group',
      'rating': 4.9,
    },
    {
      'id': 'item3',
      'name': 'Traditional Scarf',
      'price': '1200 DA',
      'image': 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3?w=800&q=80',
      'seller': 'Ahmed Artisan',
      'type': 'individual',
      'rating': 4.5,
    },
  ];

  // Wilayas
  static const List<String> allWilayas = [
    'الجزائر العاصمة', 'بجاية', 'وهران', 'قسنطينة', 'عنابة', 'تلمسان', 'سطيف', 'باتنة', 'بليدة', 'تيزي وزو'
  ];

  static const List<String> supportedWilayas = ['الجزائر العاصمة', 'بجاية'];

  // Traveler types (for planning)
  static const List<Map<String, dynamic>> travelerTypes = [
    {'id': 'solo', 'label': 'Solo', 'icon': Icons.person},
    {'id': 'couple', 'label': 'Couple', 'icon': Icons.favorite},
    {'id': 'family', 'label': 'Family', 'icon': Icons.family_restroom},
    {'id': 'friends', 'label': 'Friends', 'icon': Icons.group},
  ];

  // Budget types
  static const List<Map<String, dynamic>> budgetTypes = [
    {'id': 'economy', 'label': 'Economy', 'icon': Icons.savings},
    {'id': 'comfort', 'label': 'Comfort', 'icon': Icons.hotel},
    {'id': 'premium', 'label': 'Premium', 'icon': Icons.diamond},
  ];

  // Interest types
  static const List<Map<String, dynamic>> interestTypes = [
    {'id': 'nature', 'label': 'Nature', 'icon': Icons.forest},
    {'id': 'history', 'label': 'History', 'icon': Icons.museum},
    {'id': 'beach', 'label': 'Beach', 'icon': Icons.beach_access},
    {'id': 'food', 'label': 'Food', 'icon': Icons.restaurant},
    {'id': 'adventure', 'label': 'Adventure', 'icon': Icons.hiking},
  ];

  static const List<Map<String, dynamic>> specialNeeds = [
    {'id': 'mobility', 'label': 'Mobility Access', 'icon': Icons.accessible},
    {'id': 'dietary', 'label': 'Dietary Restrictions', 'icon': Icons.no_food},
  ];

  // AI Prompt (Updated with Safety Focus)
  static const String systemPrompt = '''You are an expert Algerian Travel Safety Guide.
Create a detailed, immersive, and SAFEST travel itinerary based on user input.
Prioritize verified locations, safe routes, and emergency awareness.
For each location:
1. Provide a "Safety Rating" (1-5).
2. Add a "Safety Tip" specifically for that spot.
3. Mark "Verified" if it's a known safe landmark.

Return JSON ONLY:
{
  "destination": "Wilaya Name",
  "safety_score": 4.8,
  "emergency_contacts": {"police": "1548", "ambulance": "14"},
  "days": [
    {
      "day": 1,
      "morning": {"place": "Name", "activity": "Safe Activity", "category": "Type", "safety_tip": "Stay in lit areas"},
      "afternoon": {"place": "Name", "activity": "Activity", "category": "Type"},
      "evening": {"place": "Name", "activity": "Activity", "tip": "Note"}
    }
  ]
}''';
}
