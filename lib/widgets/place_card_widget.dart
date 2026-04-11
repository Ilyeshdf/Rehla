import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/itinerary_model.dart';

class PlaceCardWidget extends StatelessWidget {
  final TimeSlot timeSlot;
  final String timeOfDay; 
  final VoidCallback onBook;
  final bool isVisited;
  final VoidCallback onToggleVisited;

  const PlaceCardWidget({
    super.key,
    required this.timeSlot,
    required this.timeOfDay,
    required this.onBook,
    required this.isVisited,
    required this.onToggleVisited,
  });

  Color get accentColor {
    switch (timeOfDay) {
      case 'morning':
        return AppConstants.accentTeal;
      case 'afternoon':
        return AppConstants.accentAmber;
      case 'evening':
        return AppConstants.accentGold;
      default:
        return AppConstants.accentTeal;
    }
  }

  String get timeLabel {
    switch (timeOfDay) {
      case 'morning':
        return 'MORNING';
      case 'afternoon':
        return 'AFTERNOON';
      case 'evening':
        return 'EVENING';
      default:
        return '';
    }
  }

  IconData get timeIcon {
    switch (timeOfDay) {
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'afternoon':
        return Icons.wb_cloudy_outlined;
      case 'evening':
        return Icons.nightlight_outlined;
      default:
        return Icons.schedule;
    }
  }

  Map<String, dynamic> get _placeTypeBadge {
    switch (timeSlot.placeType) {
      case PlaceType.comfortable:
        return {
          'label': 'BOOKABLE',
          'icon': Icons.hotel_outlined,
          'color': const Color(0xFF4CAF50),
        };
      case PlaceType.wild:
        return {
          'label': 'WILD',
          'icon': Icons.terrain_outlined,
          'color': const Color(0xFFFF7043),
        };
      case PlaceType.public:
        return {
          'label': 'PUBLIC',
          'icon': Icons.public_outlined,
          'color': const Color(0xFF42A5F5),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final badge = _placeTypeBadge;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isVisited
            ? AppConstants.backgroundCard.withValues(alpha: 0.6)
            : AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isVisited
              ? AppConstants.accentTeal.withValues(alpha: 0.4)
              : AppConstants.divider.withValues(alpha: 0.5),
          width: isVisited ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 12, 0),
            child: Row(
              children: [
                Icon(timeIcon, color: accentColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  timeLabel,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badge['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: (badge['color'] as Color).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badge['icon'] as IconData, size: 10, color: badge['color'] as Color),
                      const SizedBox(width: 4),
                      Text(
                        badge['label'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: badge['color'] as Color,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onToggleVisited,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isVisited
                          ? AppConstants.accentTeal
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isVisited
                            ? AppConstants.accentTeal
                            : AppConstants.textTertiary,
                        width: 2,
                      ),
                    ),
                    child: isVisited
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timeSlot.place,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isVisited
                        ? AppConstants.textTertiary
                        : AppConstants.textPrimary,
                    height: 1.2,
                    decoration: isVisited ? TextDecoration.lineThrough : null,
                    decorationColor: AppConstants.accentTeal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  timeSlot.activity,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: isVisited
                        ? AppConstants.textTertiary
                        : AppConstants.textSecondary,
                    height: 1.6,
                  ),
                ),
                if (timeSlot.tip.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundElevated.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppConstants.divider.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.tips_and_updates_outlined, color: AppConstants.accentGold, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            timeSlot.tip,
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: AppConstants.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (timeSlot.hasBooking && !isVisited) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor.withValues(alpha: 0.1),
                        foregroundColor: accentColor,
                        elevation: 0,
                        side: BorderSide(color: accentColor.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bookmark_add_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'BOOK NOW',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (isVisited) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppConstants.accentTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: AppConstants.accentTeal),
                        const SizedBox(width: 8),
                        Text(
                          'VISITED ✓',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppConstants.accentTeal,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
