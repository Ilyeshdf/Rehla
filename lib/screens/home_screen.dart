import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/quiz_model.dart';
import '../widgets/adaptive_image.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 600;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [

              SliverAppBar(
                expandedHeight: isWide ? 300 : 200,
                floating: false,
                pinned: true,
                backgroundColor: AppConstants.backgroundDark,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      AdaptiveImage(
                        imagePath: 'rihla_hero_constantine_1775887303549.png',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppConstants.backgroundDark.withValues(alpha: 0.8),
                              AppConstants.backgroundDark,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Row(
                    children: [
                      const Icon(Icons.explore_outlined, color: AppConstants.accentTeal, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'RIHLA AI',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 64 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        'START YOUR JOURNEY',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.accentTeal,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Where does your\nsafety-first trip begin?',
                        style: GoogleFonts.poppins(
                          fontSize: isWide ? 40 : 32,
                          fontWeight: FontWeight.w800,
                          color: AppConstants.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 32),

                      _buildAIPlannerCard(context, isWide),

                      const SizedBox(height: 40),

                      _buildSectionTitle('TRAVEL CATEGORIES'),
                      const SizedBox(height: 20),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isWide ? 3 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.4,
                        children: [
                          _buildCategoryItem(Icons.security, 'Safe Routes', AppConstants.accentTeal),
                          _buildCategoryItem(Icons.business, 'Work Trips', AppConstants.accentGold),
                          _buildCategoryItem(Icons.group, 'Family First', AppConstants.accentAmber),
                          _buildCategoryItem(Icons.verified_user, 'Verified Guides', Colors.greenAccent),
                        ],
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppConstants.textTertiary,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildAIPlannerCard(BuildContext context, bool isWide) {
    return GestureDetector(
      onTap: () {
        context.read<QuizProvider>().reset();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const QuizScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              AppConstants.accentTeal.withValues(alpha: 0.1),
              AppConstants.accentTeal.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppConstants.accentTeal.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: AppConstants.accentTeal.withValues(alpha: 0.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: AppConstants.accentTeal, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'SMART AI PLANNER',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.accentTeal,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Generate a customized\nsafe itinerary in seconds',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppConstants.accentTeal,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, color: AppConstants.backgroundDark, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppConstants.divider),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
