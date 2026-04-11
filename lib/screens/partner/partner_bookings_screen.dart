import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../config/constants.dart';
import '../../providers/partner_provider.dart';

class PartnerBookingsScreen extends StatefulWidget {
  const PartnerBookingsScreen({super.key});

  @override
  State<PartnerBookingsScreen> createState() => _PartnerBookingsScreenState();
}

class _PartnerBookingsScreenState extends State<PartnerBookingsScreen> {
  Future<void> _updateStatus(dynamic id, String status) async {
    await context.read<PartnerProvider>().updateBookingStatus(id, status);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'confirmed' ? 'تم تأكيد الحجز' : 'تم رفض الحجز',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor:
            status == 'confirmed' ? AppConstants.success : AppConstants.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final partner = context.watch<PartnerProvider>();
    final bookings = partner.bookings;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryGreen,
          title: Text(
            'طلبات الحجز',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => partner.fetchBookings(),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => partner.fetchBookings(),
          color: AppConstants.accentTeal,
          child: partner.isLoading 
            ? const Center(child: CircularProgressIndicator(color: AppConstants.accentTeal))
            : ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            final isNew = booking['status'] == 'pending';
            final isConfirmed = booking['status'] == 'confirmed';

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isNew
                    ? Border.all(
                        color: AppConstants.accentGold.withValues(alpha: 0.5),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: AppConstants.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['name'],
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppConstants.textDark,
                              ),
                            ),
                            Text(
                              booking['place_id'] ?? 'Unknown Place',
                              style: GoogleFonts.cairo(
                                fontSize: 13,
                                color: AppConstants.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isNew
                              ? AppConstants.accentGold.withValues(alpha: 0.15)
                              : isConfirmed
                                  ? AppConstants.success.withValues(alpha: 0.15)
                                  : AppConstants.error.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking['status'] == 'pending' ? 'جديد' : (booking['status'] == 'confirmed' ? 'مؤكد' : 'مرفوض'),
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isNew
                                ? AppConstants.accentGold
                                : isConfirmed
                                    ? AppConstants.success
                                    : AppConstants.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _detailChip(Icons.calendar_today, booking['date']),
                      const SizedBox(width: 12),
                      _detailChip(
                          Icons.group, '${booking['guests']} أشخاص'),
                    ],
                  ),

                  if (isNew) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _updateStatus(booking['id'], 'confirmed'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.success,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'تأكيد',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              onPressed: () =>
                                  _updateStatus(booking['id'], 'rejected'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppConstants.error,
                                side: const BorderSide(
                                  color: AppConstants.error,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'رفض',
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

  Widget _detailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCream,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppConstants.textMedium),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: AppConstants.textMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
