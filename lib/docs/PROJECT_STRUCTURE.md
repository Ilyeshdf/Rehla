# Rihla Project Structure

Here is the architectural structure of your `Rihla` application's `lib/` directory, mapped out logically to show exactly how the codebase is organized:

```text
lib/
├── main.dart                             # Application Entry Point
│
├── config/                               # Settings & Theming Constants
│   ├── constants.dart                    # App-wide colors, strings, mock data
│   └── theme.dart                        # Centralized Flutter theme settings
│
├── data/                                 # Local/Mock Data
│   └── places_data.dart                  # (Will eventually connect to Supabase DB)
│
├── docs/                                 # Internal Architecture Documentation
│   ├── AI_GOVERNANCE.md                  # Guidelines for Rihla's embedded AI
│   ├── PROJECT_STRUCTURE.md              # THIS FILE - App layout overview
│   └── SYSTEM_ARCHITECTURE.md            # App core tech-stack layout overview
│
├── models/                               # Data Models (Supabase tables map to these)
│   ├── user_model.dart                   # Users
│   ├── place_model.dart                  # Tourism places (+ guides & AI Metadata)
│   ├── itinerary_model.dart              # AI-generated itineraries
│   ├── booking_model.dart                # Bookings/reservations logic
│   ├── post_model.dart                   # Social feed posts
│   ├── achievement_model.dart            # Gamification XP/badges
│   ├── journey_model.dart                # Journey logs tracking
│   ├── leaderboard_entry_model.dart      # Leaderboard tracking
│   └── quiz_model.dart                   # AI recommendation quiz state
│
├── providers/                            # State Management (Provider Package)
│   ├── navigation_provider.dart          # Manages bottom navigation bar states
│   ├── user_provider.dart                # Handles user authentication & sessions
│   ├── feed_provider.dart                # Controls the social feed logic
│   ├── journey_provider.dart             # Controls safety and live tracking
│   └── leaderboard_provider.dart         # Manages high-scores & rank
│
├── screens/                              # All App UI Pages/Screens
│   ├── main_navigator.dart               # The bottom navigation foundation
│   ├── splash_screen.dart                # Initial boot loading screen
│   ├── home_screen.dart                  # AI Chatbot/Planning entry point
│   ├── loading_screen.dart               # AI loading animation screen
│   ├── quiz_screen.dart                  # AI generation preference questions
│   ├── itinerary_screen.dart             # Generated itinerary timeline UI
│   ├── booking_confirmation_screen.dart  # Booking conclusion UI
│   │
│   ├── gamification/                     # Social & Gamified Loop
│   │   ├── social_feed_screen.dart       # Instagram-like feed for travelers
│   │   ├── camera_capture_screen.dart    # Camera with AR/Filters logic
│   │   ├── post_creator_screen.dart      # Where users type their caption
│   │   ├── achievement_unlock_screen.dart# Gamified Badge UI (M2/XP popup)
│   │   ├── explorer_profile_screen.dart  # User's page with level & badges
│   │   ├── leaderboard_screen.dart       # Rankings for gamification
│   │   └── journey_tracker_screen.dart   # Live map & safety/emergency tracking
│   │
│   └── partner/                          # Business Interface (B2B features)
│       ├── partner_dashboard_screen.dart # Overview for business owner
│       ├── partner_bookings_screen.dart  # Manage reservations (Accept/Reject)
│       └── partner_listing_screen.dart   # Business profile management
│
├── services/                             # External APIs and Background Logic
│   ├── ai_service.dart                   # Bridge for communication with the AI
│   ├── location_service.dart             # Handles live GPS & Geolocator
│   ├── whatsapp_service.dart             # Redirects links/chats into WhatsApp
│   │
│   └── agents/                           # Multi-Agent Language Model logic
│       ├── orchestrator.dart             # Director that assigns AI tasks
│       ├── base_agent.dart               # Abstract interface for agents
│       └── agent_definitions.dart        # Different specific agents (e.g. Budget Agent)
│
└── widgets/                              # Reusable UI Components
    ├── progress_bar_widget.dart          # Shows quiz completion status
    ├── quiz_step_widget.dart             # Reusable questions for the quiz
    ├── day_card_widget.dart              # Card representing a single itinerary day
    ├── place_card_widget.dart            # The places to visit on day cards
    └── booking_modal_widget.dart         # Bottom sheet UI that slides up to book
```

### Architecture Summary:
1. **Frontend**: Cleanly modularized using the **MVC (Models-Views-Controllers/Providers)** structure. Pure logic lies inside `providers/`, UI shells and views reside in `screens/` and `widgets/`, and external network endpoints sit inside `services/`.
2. **Features Segregation**: We've split the core experiences intelligently: AI/planning lives mainly on `home_screen`, while the whole social/competition loop is neatly isolated inside `gamification/`, and B2B logic is nested within `partner/`.
