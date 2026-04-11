import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../config/constants.dart';
import '../models/booking_model.dart';
import '../services/whatsapp_service.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({super.key, required this.booking});

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppConstants.accentTeal.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppConstants.accentTeal, width: 2),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: AppConstants.accentTeal,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'BOOKING SUCCESSFUL',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppConstants.textPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your spot is reserved at the destination',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppConstants.backgroundCard,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppConstants.divider),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Text(
                                    'BOOKING REFERENCE',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppConstants.textTertiary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppConstants.backgroundElevated,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppConstants.accentGold.withValues(alpha: 0.3)),
                                    ),
                                    child: Text(
                                      widget.booking.referenceNumber,
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppConstants.accentGold,
                                        letterSpacing: 6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              children: List.generate(20, (i) => Expanded(
                                child: Container(
                                  height: 1,
                                  color: i % 2 == 0 ? AppConstants.divider : Colors.transparent,
                                ),
                              )),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  _summaryRow(Icons.place_outlined, 'DESTINATION', widget.booking.placeName),
                                  const SizedBox(height: 16),
                                  _summaryRow(Icons.calendar_today_outlined, 'DATE', 
                                    intl.DateFormat('MMM dd, yyyy').format(widget.booking.date)),
                                  const SizedBox(height: 16),
                                  _summaryRow(Icons.group_outlined, 'PARTY SIZE', '${widget.booking.numberOfGuests} GUESTS'),
                                  const SizedBox(height: 16),
                                  _summaryRow(Icons.person_outline, 'HOLDER', widget.booking.fullName.toUpperCase()),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.accentTeal,
                            foregroundColor: AppConstants.backgroundDark,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(
                            'RETURN TO ITINERARY',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            WhatsAppService.shareBookingConfirmation(
                              placeName: widget.booking.placeName,
                              reference: widget.booking.referenceNumber,
                              date: intl.DateFormat('MMM dd, yyyy').format(widget.booking.date),
                              guests: widget.booking.numberOfGuests,
                            );
                          },
                          icon: const Icon(Icons.share, size: 20),
                          label: Text(
                            'SHARE CONFIRMATION',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 1,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF25D366),
                            side: const BorderSide(color: Color(0xFF25D366)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.textTertiary, size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppConstants.textTertiary,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
