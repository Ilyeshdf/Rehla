import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/leaderboard_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/leaderboard_entry_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(child: _buildHeader()),

          // Tab Bar
          SliverToBoxAdapter(child: _buildTabBar()),

          SliverFillRemaining(
            child: Consumer2<LeaderboardProvider, UserProvider>(
              builder: (context, leaderboard, userProvider, _) {
                if (leaderboard.isLoading || userProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppConstants.accentTeal),
                  );
                }

                if (userProvider.currentUser != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      leaderboard.insertCurrentUser(userProvider.currentUser!);
                    }
                  });
                }

                return Column(
                  children: [
                    // Podium Top 3
                    if (leaderboard.entries.length >= 3)
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPodium(leaderboard.entries[1], 2, 80),
                            _buildPodium(leaderboard.entries[0], 1, 110),
                            _buildPodium(leaderboard.entries[2], 3, 65),
                          ],
                        ),
                      ),

                    Divider(
                        color: AppConstants.divider.withValues(alpha: 0.5),
                        height: 1),

                    // Rest of Leaderboard
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: leaderboard.entries.length > 3
                            ? leaderboard.entries.length - 3
                            : 0,
                        itemBuilder: (context, index) {
                          final i = index + 3;
                          final entry = leaderboard.entries[i];
                          final isMe =
                              userProvider.currentUser?.id == entry.userId;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? AppConstants.accentTeal
                                      .withValues(alpha: 0.08)
                                  : AppConstants.backgroundCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isMe
                                    ? AppConstants.accentTeal
                                        .withValues(alpha: 0.3)
                                    : AppConstants.divider
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    '${entry.rank}',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: AppConstants.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isMe
                                      ? AppConstants.accentTeal
                                          .withValues(alpha: 0.2)
                                      : AppConstants.backgroundElevated,
                                  child: Text(
                                    entry.username.substring(0, 1),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: isMe
                                          ? AppConstants.accentTeal
                                          : AppConstants.textSecondary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            entry.username,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: AppConstants.textPrimary,
                                            ),
                                          ),
                                          if (isMe)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppConstants.accentTeal,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                'YOU',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppConstants
                                                      .backgroundDark,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Text(
                                        '${entry.wilaya} • ${entry.badge}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppConstants.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${entry.xp} XP',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: AppConstants.accentGold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '${entry.placesUnlocked} places',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: AppConstants.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      color: AppConstants.backgroundCard,
      child: Row(
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
          const SizedBox(width: 12),
          Text(
            'Leaderboard',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConstants.textSecondary,
            ),
          ),
          const Spacer(),
          const Icon(Icons.emoji_events,
              color: AppConstants.accentGold, size: 24),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppConstants.backgroundCard,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppConstants.accentTeal,
        indicatorWeight: 3,
        labelColor: AppConstants.accentTeal,
        unselectedLabelColor: AppConstants.textTertiary,
        labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        dividerColor: AppConstants.divider.withValues(alpha: 0.5),
        tabs: const [
          Tab(text: 'This Week'),
          Tab(text: 'This Month'),
          Tab(text: 'All Time'),
        ],
      ),
    );
  }

  Widget _buildPodium(LeaderboardEntryModel entry, int rank, double height) {
    Color medalColor;
    if (rank == 1) {
      medalColor = AppConstants.accentGold;
    } else if (rank == 2) {
      medalColor = const Color(0xFFA0A8B8);
    } else {
      medalColor = const Color(0xFFCD7F32);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Crown for first place
        if (rank == 1)
          const Icon(Icons.military_tech,
              color: AppConstants.accentGold, size: 28),
        if (rank == 1) const SizedBox(height: 4),

        // Avatar
        Container(
          width: rank == 1 ? 56 : 44,
          height: rank == 1 ? 56 : 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [medalColor, medalColor.withValues(alpha: 0.6)],
            ),
            border: Border.all(color: medalColor, width: 2),
          ),
          child: Center(
            child: Text(
              entry.username.substring(0, 1),
              style: GoogleFonts.poppins(
                fontSize: rank == 1 ? 22 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry.username,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            color: AppConstants.textSecondary,
          ),
        ),
        Text(
          '${entry.xp} XP',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppConstants.accentGold,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: rank == 1 ? 80 : 65,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                medalColor.withValues(alpha: 0.25),
                medalColor.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: medalColor.withValues(alpha: 0.3)),
          ),
          child: Center(
            child: Text(
              '$rank',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: medalColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
