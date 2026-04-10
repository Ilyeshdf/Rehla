import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/user_provider.dart';
import '../../models/quiz_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/journey_provider.dart';
import 'leaderboard_screen.dart';

class ExplorerProfileScreen extends StatelessWidget {
  const ExplorerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading || userProvider.currentUser == null) {
          return const Scaffold(
            backgroundColor: AppConstants.backgroundDark,
            body: Center(
              child: CircularProgressIndicator(color: AppConstants.accentTeal),
            ),
          );
        }

        final user = userProvider.currentUser!;

        final int nextLevelXp = user.xp < 100
            ? 100
            : user.xp < 300
                ? 300
                : user.xp < 600
                    ? 600
                    : user.xp < 1000
                        ? 1000
                        : user.xp < 2000
                            ? 2000
                            : 5000;

        final double progress = min(user.xp / nextLevelXp, 1.0);

        return Scaffold(
          backgroundColor: AppConstants.backgroundDark,
          body: CustomScrollView(
            slivers: [
              // Profile Header
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 16, 20, 30),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundCard,
                    border: Border(
                      bottom: BorderSide(
                        color: AppConstants.divider.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top row
                      Row(
                        children: [
                          Text(
                            'RIHLA',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textPrimary,
                              letterSpacing: 2,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.leaderboard_outlined,
                                color: AppConstants.accentGold),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const LeaderboardScreen(),
                              ));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined,
                                color: AppConstants.textTertiary),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Avatar & Rank
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppConstants.accentTeal,
                                  AppConstants.accentTeal.withValues(alpha: 0.5),
                                ],
                              ),
                              border: Border.all(
                                color: AppConstants.accentTeal.withValues(alpha: 0.5),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppConstants.accentTeal
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                user.username.substring(0, 1),
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.accentGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${user.rank > 0 ? user.rank : "--"}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: AppConstants.backgroundDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        user.username,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppConstants.textPrimary,
                        ),
                      ),

                      // Location badge
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppConstants.backgroundElevated,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.place,
                                color: AppConstants.accentGold, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              user.wilaya,
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Level & XP Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.level,
                            style: GoogleFonts.poppins(
                              color: AppConstants.accentGold,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${user.xp} / $nextLevelXp XP',
                            style: GoogleFonts.poppins(
                              color: AppConstants.textSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: AppConstants.backgroundDark,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppConstants.accentTeal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Stats Row
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      _buildStatBox('Trails', '0', Icons.route),
                      const SizedBox(width: 10),
                      _buildStatBox('Places',
                          '${user.unlockedAchievements.length}', Icons.place),
                      const SizedBox(width: 10),
                      _buildStatBox('Photos', '0', Icons.camera_alt),
                    ],
                  ),
                ),
              ),

              // Start Journey CTA
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final journey = context.read<JourneyProvider>();
                        if (!journey.isActive) {
                          context.read<QuizProvider>().reset();
                          journey.startJourney();
                        }
                        // Navigate to the Journey Tab (index 2)
                        context.read<NavigationProvider>().setIndex(2);
                      },
                      icon: const Icon(Icons.play_circle_fill, size: 24),
                      label: Text(
                        'START A JOURNEY',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.accentTeal,
                        foregroundColor: AppConstants.backgroundDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Achievements Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'Achievements',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                ),
              ),

              // Achievements Grid
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final ach = userProvider.allAchievements[index];
                      return _buildAchievementBadge(ach);
                    },
                    childCount: userProvider.allAchievements.length,
                  ),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppConstants.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppConstants.divider),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppConstants.accentTeal, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppConstants.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppConstants.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(var achievement) {
    final bool isUnlocked = achievement.isUnlocked;

    return Container(
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? AppConstants.accentGold.withValues(alpha: 0.4)
              : AppConstants.divider,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? AppConstants.accentGold.withValues(alpha: 0.1)
                  : AppConstants.backgroundElevated,
              border: Border.all(
                color: isUnlocked
                    ? AppConstants.accentGold.withValues(alpha: 0.4)
                    : AppConstants.divider,
                width: isUnlocked ? 2 : 1,
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: AppConstants.accentGold.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                achievement.badgeEmoji,
                style: TextStyle(
                  fontSize: 24,
                  color: isUnlocked
                      ? null
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              achievement.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
                color: isUnlocked
                    ? AppConstants.textPrimary
                    : AppConstants.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
