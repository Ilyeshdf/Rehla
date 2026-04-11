import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/itinerary_model.dart';
import 'place_card_widget.dart';

class DayCardWidget extends StatelessWidget {
  final ItineraryDay day;
  final Function(String placeName, String category, {String? pid, String? plid}) onBook;
  final Set<String> visitedPlaces;
  final Function(String placeKey) onToggleVisited;

  const DayCardWidget({
    super.key,
    required this.day,
    required this.onBook,
    required this.visitedPlaces,
    required this.onToggleVisited,
  });

  String _placeKey(int dayNum, String timeOfDay) => '${dayNum}_$timeOfDay';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppConstants.accentTeal,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'YOUR SCHEDULE FOR DAY ${day.day}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),

              _buildDayProgress(),
            ],
          ),
          const SizedBox(height: 24),

          PlaceCardWidget(
            timeSlot: day.morning,
            timeOfDay: 'morning',
            onBook: () => onBook(day.morning.place, day.morning.category, pid: day.morning.partnerId, plid: day.morning.placeId),
            isVisited: visitedPlaces.contains(_placeKey(day.day, 'morning')),
            onToggleVisited: () => onToggleVisited(_placeKey(day.day, 'morning')),
          ),

          PlaceCardWidget(
            timeSlot: day.afternoon,
            timeOfDay: 'afternoon',
            onBook: () => onBook(day.afternoon.place, day.afternoon.category, pid: day.afternoon.partnerId, plid: day.afternoon.placeId),
            isVisited: visitedPlaces.contains(_placeKey(day.day, 'afternoon')),
            onToggleVisited: () => onToggleVisited(_placeKey(day.day, 'afternoon')),
          ),

          PlaceCardWidget(
            timeSlot: day.evening,
            timeOfDay: 'evening',
            onBook: () => onBook(day.evening.place, day.evening.category, pid: day.evening.partnerId, plid: day.evening.placeId),
            isVisited: visitedPlaces.contains(_placeKey(day.day, 'evening')),
            onToggleVisited: () => onToggleVisited(_placeKey(day.day, 'evening')),
          ),
        ],
      ),
    );
  }

  Widget _buildDayProgress() {
    int total = 3;
    int visited = 0;
    if (visitedPlaces.contains(_placeKey(day.day, 'morning'))) visited++;
    if (visitedPlaces.contains(_placeKey(day.day, 'afternoon'))) visited++;
    if (visitedPlaces.contains(_placeKey(day.day, 'evening'))) visited++;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: visited == total
            ? AppConstants.accentTeal.withValues(alpha: 0.15)
            : AppConstants.backgroundElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$visited/$total',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: visited == total
              ? AppConstants.accentTeal
              : AppConstants.textTertiary,
        ),
      ),
    );
  }
}
