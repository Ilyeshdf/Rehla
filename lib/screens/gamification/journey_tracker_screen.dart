import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/journey_provider.dart';
import '../../providers/user_provider.dart';
import 'camera_capture_screen.dart';
import 'post_creator_screen.dart';
import '../../providers/navigation_provider.dart';

class JourneyTrackerScreen extends StatelessWidget {
  const JourneyTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final journey = context.watch<JourneyProvider>();

    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundDark,
        elevation: 0,
        title: Text(
          'ACTIVE JOURNEY',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 2),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shield_outlined, color: AppConstants.accentTeal),
          ),
        ],
      ),
      body: !journey.isActive 
        ? _buildEmptyState(context)
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emergency SOS Button (Primary Safety Action)
                _buildSOSButton(),
                const SizedBox(height: 32),

                // Live Tracking Card
                _buildLiveTrackingCard(journey),
                const SizedBox(height: 24),

                // Journey Actions (Camera + End)
                _buildJourneyActions(context, journey),
                const SizedBox(height: 32),

                _buildSectionTitle('VERIFIED EMERGENCY CONTACTS'),
                const SizedBox(height: 16),
                _buildContactRow('National Police', '1548', Icons.local_police),
                _buildContactRow('Civil Protection', '14', Icons.fire_truck),
                _buildContactRow('Gendarmerie', '1055', Icons.security),

                const SizedBox(height: 32),
                _buildSectionTitle('SAFETY TOOLS'),
                const SizedBox(height: 16),
                _buildSafetyTool('Verified Guides Near You', Icons.verified_user),
                _buildSafetyTool('Real-time Safe Zones', Icons.map_outlined),
                _buildSafetyTool('Check-in with Family', Icons.family_restroom),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppConstants.accentTeal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.route_outlined, color: AppConstants.accentTeal, size: 64),
            ),
            const SizedBox(height: 32),
            Text(
              'NO ACTIVE JOURNEY',
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: AppConstants.textPrimary, letterSpacing: 1),
            ),
            const SizedBox(height: 12),
            Text(
              'Start a new adventure to track your progress and capture moments.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: AppConstants.textSecondary),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  context.read<NavigationProvider>().setIndex(1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.accentTeal,
                  foregroundColor: AppConstants.backgroundDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('START JOURNEY NOW', style: GoogleFonts.poppins(fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSOSButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.liveRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppConstants.liveRed.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: AppConstants.liveRed, shape: BoxShape.circle),
            child: const Icon(Icons.emergency_share, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            'SIGNAL EMERGENCY',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w800, color: AppConstants.liveRed, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            'Instantly alert local authorities & family',
            style: GoogleFonts.poppins(fontSize: 12, color: AppConstants.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTrackingCard(JourneyProvider journey) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppConstants.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppConstants.accentTeal, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                'LIVE TRACKING ACTIVE',
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: AppConstants.accentTeal, letterSpacing: 1),
              ),
              const Spacer(),
              const Icon(Icons.share_location, color: AppConstants.textTertiary, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${journey.distanceKm.toStringAsFixed(1)} KM Travelled',
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w800, color: AppConstants.textPrimary),
          ),
          Text(
            'Bejaia Coastline Route',
            style: GoogleFonts.poppins(fontSize: 14, color: AppConstants.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyActions(BuildContext context, JourneyProvider journey) {
    return Row(
      children: [
        // Camera Button
        Expanded(
          child: _buildActionButton(
            context,
            'CAPTURE MOMENT',
            Icons.camera_alt,
            AppConstants.accentTeal,
            () async {
              final String? imagePath = await Navigator.of(context).push<String>(
                MaterialPageRoute(
                  builder: (_) => CameraCaptureScreen(
                    locationName: journey.placeName ?? 'My Discovery',
                  ),
                ),
              );

              if (imagePath != null && context.mounted) {
                journey.addPhoto(imagePath);
                final user = context.read<UserProvider>().currentUser;
                if (user != null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PostCreatorScreen(
                        journey: journey.getCurrentJourney(user.id, journey.placeName),
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // End Journey Button
        Expanded(
          child: _buildActionButton(
            context,
            'FINISH JOURNEY',
            Icons.stop_circle,
            AppConstants.liveRed,
            () {
              final user = context.read<UserProvider>().currentUser;
              if (user != null) {
                journey.endJourney(user.id, journey.placeName ?? 'Exploring Algeria');
                // Switch back to Profile tab
                context.read<NavigationProvider>().setIndex(3);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journey completed and saved!')),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppConstants.textTertiary, letterSpacing: 1.5),
    );
  }

  Widget _buildContactRow(String name, String number, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.accentTeal, size: 22),
          const SizedBox(width: 16),
          Expanded(child: Text(name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppConstants.textPrimary))),
          Text(number, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: AppConstants.accentTeal)),
        ],
      ),
    );
  }

  Widget _buildSafetyTool(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.textSecondary, size: 22),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppConstants.textPrimary))),
          const Icon(Icons.arrow_forward_ios, color: AppConstants.textTertiary, size: 14),
        ],
      ),
    );
  }
}
