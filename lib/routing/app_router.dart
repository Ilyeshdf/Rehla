import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/main_navigator.dart';
import '../screens/quiz_screen.dart';
import '../screens/itinerary_screen.dart';
import '../screens/gamification/leaderboard_screen.dart';
import '../screens/gamification/camera_capture_screen.dart';
import '../screens/gamification/post_creator_screen.dart';
import '../screens/partner/partner_dashboard_screen.dart';
import '../screens/partner/partner_bookings_screen.dart';
import '../screens/partner/partner_listing_screen.dart';
import '../screens/loading_screen.dart';
import '../screens/booking_confirmation_screen.dart';
import '../models/itinerary_model.dart';
import '../models/quiz_model.dart';
import '../models/booking_model.dart';
import '../models/journey_model.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case RouteNames.main:
        return MaterialPageRoute(builder: (_) => const MainNavigator());
      
      case RouteNames.quiz:
        return MaterialPageRoute(builder: (_) => const QuizScreen());
      
      case RouteNames.itinerary:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ItineraryScreen(
            itinerary: args['itinerary'] as Itinerary,
            quizAnswers: args['quizAnswers'] as QuizAnswers,
          ),
        );
      
      case RouteNames.leaderboard:
        return MaterialPageRoute(builder: (_) => const LeaderboardScreen());
      
      case RouteNames.camera:
        final locationName = settings.arguments as String? ?? 'Algeria';
        return MaterialPageRoute(
          builder: (_) => CameraCaptureScreen(locationName: locationName),
        );
      
      case RouteNames.postCreator:
        final journey = settings.arguments as JourneyModel;
        return MaterialPageRoute(
          builder: (_) => PostCreatorScreen(journey: journey),
        );
      
      case RouteNames.partnerDashboard:
        return MaterialPageRoute(builder: (_) => const PartnerDashboardScreen());
      
      case RouteNames.partnerBookings:
        return MaterialPageRoute(builder: (_) => const PartnerBookingsScreen());
      
      case RouteNames.partnerListing:
        return MaterialPageRoute(builder: (_) => const PartnerListingScreen());
      
      case RouteNames.loading:
        final quizAnswers = settings.arguments as QuizAnswers;
        return MaterialPageRoute(
          builder: (_) => LoadingScreen(quizAnswers: quizAnswers),
        );
      
      case RouteNames.bookingConfirmation:
        final booking = settings.arguments as Booking;
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: booking),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}