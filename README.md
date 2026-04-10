# 🐪 Rihla (رحلة) - Algeria's AI-Powered Vacation Planning App

![Rihla Hero](https://github.com/user-attachments/assets/placeholder.png) <!-- Update with actual hero graphic -->

**Rihla** is a next-generation vacation planning app built for exploring the vibrant beauty of Algeria. Empowered by an AI conversational agent (speaking Algerian Darija and standard dialects) and deeply connected to local tourism providers, Rihla simplifies finding trips, managing itineraries, and sharing experiences. Rihla redefines local tourism by gamifying exploration, enabling dynamic booking, and turning every trip into an unforgettable journey.

---

## ✨ Features

### 🤖 AI-Powered Itineraries
Rihla utilizes an advanced AI Planner that dynamically curates personalized itineraries for your vacation based on your preferences, budget, and real-time geographical analytics. Your trip is broken down into structured, easy-to-follow daily milestones.

### 🎮 Gamification & Social Connection
Earn experience and rank up your explorer profile as you explore the Sahara and the coastal cities!
- **Explorer Profile**: Track your journey stats, achievements, and unlocked badges.
- **Social Feed**: View posts, images, and reviews shared by fellow Rihla travelers.
- **Leaderboards**: Compete with other explorers in your community.
- **In-App Camera Capture & Post Creator**: Document your experiences securely and share them straight to the feed.

### 📅 Booking & Partner Network
Local hoteliers, drivers, and tour guides can list themselves on Rihla's **Partner Portal**, allowing travelers to directly confirm bookings and manage reservations in-app.

### 🗺 Maps & Navigation Integration
Direct integration with Google Maps helps you navigate effectively and visualize your next destination seamlessly using on-device location tracking (`geolocator`).

---

## 🛠 Tech Stack

Rihla is a scalable, cross-platform mobile application powered by modern frameworks and backend services:

- **Frontend**: Flutter (Cross-Platform iOS/Android/Web)
- **State Management**: `provider` pattern architecture
- **Backend Infrastructure**: Supabase (Postgres Database, Authentication, and Edge Functions)
- **AI Integration**: Custom Language/Conversational Agents + `http` service calls
- **Aesthetics & UI**: Modern UI powered by `lottie` animations, `google_fonts`, and `cupertino_icons`
- **Native Interops**:
  - `camera` and `image_picker` for gamified captures
  - `google_maps_flutter` for GIS intelligence
  - `geolocator` and `sensors_plus` for real-time telemetry

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.11.0` or higher
- **Android Studio** or **Xcode** (for simulator access and native builds)
- **Supabase Account** (if contributing to backend configuration)

### Installation
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/your-username/rehla.git
   ```
2. Navigate into the project directory:
   ```bash
   cd rehla
   ```
3. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```
4. Configure required environmental keys (like Supabase API strings and Google Maps keys) in a `.env` file or within your constants map inside `lib/config/constants.dart`/`lib/main.dart` (depending on your setup).

### Running the App
To run the app interactively on an emulator or a physical device:
```bash
flutter run
```

To run as a web application (which supports `WASM` compilation):
```bash
flutter build web
flutter run -d chrome
```

---

## 📂 Project Structure (Overview)
- **`lib/screens/`**: Primary application UI screens (Splash, Home, Loading).
  - **`gamification/`**: Core views for social feed, leaderboards, profiles, achievements, and camera capturing.
  - **`partner/`**: Screens meant for business partners (listings and incoming bookings).
- **`lib/services/`**: Core API and backend calls (Supabase integration, AI service logic).
- **`lib/widgets/`**: Reusable component classes representing UI logic distinct from entire screens.
- **`lib/docs/`**: Documentation including AI Governance (`AI_GOVERNANCE.md`).

---

## 🤝 Contributing
Contributions, patches, and feature requests are welcome! 
1. Fork the Project.
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request.

---

## 📄 License
This project is proprietary and currently developed for specific usage. (Update this section with an open-source license like MIT or GPL if this codebase is released to the public).

---
*Built with ❤️ for Algeria.*
