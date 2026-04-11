import 'package:flutter/material.dart';

class AppConstants {

  static const String groqApiKey = 'YOUR_GROQ_API_KEY_HERE';
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String groqModel = 'llama-3.3-70b-versatile';

  static const String grokApiKey = 'YOUR_GROK_API_KEY_HERE';
  static const String grokApiUrl = 'https://api.x.ai/v1/chat/completions';
  static const String grokModel = 'grok-beta';

  static const String supabaseUrl = 'YOUR_SUPABASE_URL_HERE';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY_HERE';

  static const Color backgroundMain = Color(0xFFFFFFFF);
  static const Color backgroundCard = Color(0xFFF5F7FA);
  static const Color backgroundElevated = Color(0xFFEDF0F5);
  static const Color backgroundDim = Color(0xFFF9FAFB);

  static const Color accentTeal = Color(0xFF00C9B1);
  static const Color accentTealLight = Color(0xFF33D4C1);
  static const Color accentGold = Color(0xFFD4A04A);
  static const Color accentAmber = Color(0xFFF9A825);

  static const Color textPrimary = Color(0xFF1B2B4B);
  static const Color textSecondary = Color(0xFF5A6B89);
  static const Color textTertiary = Color(0xFF8E9EB6);

  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFCA28);
  static const Color info = Color(0xFF42A5F5);

  static const Color divider = Color(0xFFE1E5ED);
  static const Color border = Color(0xFF1E2338);

  // Deprecated/Legacy aliases for backward compatibility (Optional: cleanup)
  static const Color backgroundWhite = backgroundMain;
  static const Color backgroundDark = backgroundMain;
  static const Color backgroundCream = backgroundCard;
  static const Color primaryGreen = accentTeal;
  static const Color primaryGreenLight = accentTealLight;
  static const Color textDark = textPrimary;
  static const Color textMedium = textSecondary;
  static const Color textLight = textTertiary;

  static const List<Map<String, dynamic>> buyerTypes = [
    {'id': 'individual', 'label': 'Individual', 'ar': 'فردي', 'icon': Icons.person},
    {'id': 'group', 'label': 'Group', 'ar': 'مجموعة', 'icon': Icons.group},
    {'id': 'company', 'label': 'Company', 'ar': 'شركة', 'icon': Icons.business},
  ];

  static const List<Map<String, dynamic>> storeItems = [
    {
      'id': 'item1',
      'name': 'Pro Hiking Gear',
      'price': '4500 DA',
      'image': 'https://images.unsplash.com/photo-1551632811-561732d1e306?auto=format&fit=crop&w=800&q=80',
      'seller': 'Decathlon DZ',
      'type': 'company',
      'rating': 4.8,
    },
    {
      'id': 'item2',
      'name': 'Desert Camping Tent',
      'price': '8200 DA',
      'image': 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?auto=format&fit=crop&w=800&q=80',
      'seller': 'Sahara Nomads',
      'type': 'group',
      'rating': 4.9,
    },
    {
      'id': 'item3',
      'name': 'Traditional Scarf',
      'price': '1200 DA',
      'image': 'https://images.unsplash.com/photo-1623583522203-b0521e1d0337?auto=format&fit=crop&w=800&q=80',
      'seller': 'Ahmed Artisan',
      'type': 'individual',
      'rating': 4.5,
    },
  ];

  static const List<String> allWilayas = [
    'الجزائر العاصمة', 'بجاية', 'قسنطينة', 'جانت', 'وهران', 'عنابة', 'تلمسان', 'سطيف', 'باتنة', 'بليدة', 'تيزي وزو'
  ];

  static const List<String> supportedWilayas = ['الجزائر العاصمة', 'بجاية', 'قسنطينة', 'جانت'];

  static const List<Map<String, dynamic>> travelerTypes = [
    {'id': 'solo', 'label': 'Solo', 'icon': Icons.person},
    {'id': 'couple', 'label': 'Couple', 'icon': Icons.favorite},
    {'id': 'family', 'label': 'Family', 'icon': Icons.family_restroom},
    {'id': 'friends', 'label': 'Friends', 'icon': Icons.group},
  ];

  static const List<Map<String, dynamic>> budgetTypes = [
    {'id': 'economy', 'label': 'Economy', 'icon': Icons.savings},
    {'id': 'comfort', 'label': 'Comfort', 'icon': Icons.hotel},
    {'id': 'premium', 'label': 'Premium', 'icon': Icons.diamond},
  ];

  static const List<Map<String, dynamic>> interestTypes = [
    {'id': 'nature', 'label': 'Nature', 'icon': Icons.forest},
    {'id': 'history', 'label': 'History', 'icon': Icons.museum},
    {'id': 'beach', 'label': 'Beach', 'icon': Icons.beach_access},
    {'id': 'food', 'label': 'Food', 'icon': Icons.restaurant},
    {'id': 'adventure', 'label': 'Adventure', 'icon': Icons.hiking},
    {'id': 'hotels', 'label': 'Hotels & Riads', 'icon': Icons.hotel},
  ];

  static const List<Map<String, dynamic>> specialNeeds = [
    {'id': 'mobility', 'label': 'Mobility Access', 'icon': Icons.accessible},
    {'id': 'dietary', 'label': 'Dietary Restrictions', 'icon': Icons.no_food},
  ];

  static const String systemPrompt = '''You are Rihla, the Mediterranean Horizon AI Assistant, designed by architect Haddef Mohamed Ilyes.
You act as a "DATA SAVER" recommendation system that makes users feel the value of their hiking and climbing achievements.
Create a detailed, immersive, and SAFEST travel itinerary based on user input.
Prioritize real places, community-verified routes, and emergency awareness.
For each location:
1. Provide a "Safety Rating" (1-5).
2. Add a "Safety Tip" specifically for that spot.
3. Mark "Verified" if it's a known safe landmark from our community data.

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
