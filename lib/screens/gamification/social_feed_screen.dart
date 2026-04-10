import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../providers/feed_provider.dart';
import '../../models/post_model.dart';
import 'leaderboard_screen.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBuyerType = 0; // 0: All, 1: Individual, 2: Group, 3: Company

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundDark,
        elevation: 0,
        title: Text(
          'Community',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const LeaderboardScreen(),
              ));
            },
            icon: const Icon(Icons.leaderboard_outlined, color: AppConstants.accentGold),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppConstants.accentTeal,
          labelColor: AppConstants.accentTeal,
          unselectedLabelColor: AppConstants.textTertiary,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'EXPLORERS'),
            Tab(text: 'MARKETPLACE'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildExplorersFeed(),
          _buildMarketplace(),
        ],
      ),
    );
  }

  Widget _buildExplorersFeed() {
    final feed = context.watch<FeedProvider>();
    if (feed.isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppConstants.accentTeal));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: feed.posts.length,
      itemBuilder: (context, index) {
        final post = feed.posts[index];
        return _buildPostCard(post, feed);
      },
    );
  }

  Widget _buildMarketplace() {
    return Column(
      children: [
        // Buyer Type Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildFilterChip('All', 0),
              _buildFilterChip('Individual', 1),
              _buildFilterChip('Group', 2),
              _buildFilterChip('Company', 3),
            ],
          ),
        ),
        
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: _getFilteredItems().length,
            itemBuilder: (context, index) {
              final item = _getFilteredItems()[index];
              return _buildStoreItem(item);
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    if (_selectedBuyerType == 0) return AppConstants.storeItems;
    final types = ['all', 'individual', 'group', 'company'];
    return AppConstants.storeItems.where((item) => item['type'] == types[_selectedBuyerType]).toList();
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedBuyerType == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedBuyerType = index),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.accentTeal : AppConstants.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppConstants.accentTeal : AppConstants.divider),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppConstants.backgroundDark : AppConstants.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildStoreItem(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppConstants.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(item['image'], fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: AppConstants.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      item['type'] == 'company' ? Icons.business : 
                      item['type'] == 'group' ? Icons.group : Icons.person,
                      size: 10,
                      color: AppConstants.accentGold,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item['seller'],
                      style: GoogleFonts.poppins(fontSize: 10, color: AppConstants.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['price'],
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w800, color: AppConstants.accentTeal),
                    ),
                    const Icon(Icons.add_shopping_cart, color: AppConstants.accentTeal, size: 18),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(PostModel post, FeedProvider feed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppConstants.backgroundCard,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppConstants.accentTeal.withValues(alpha: 0.1), child: Text(post.username[0].toUpperCase(), style: const TextStyle(color: AppConstants.accentTeal))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(post.username, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: AppConstants.textPrimary)),
                    Text(post.wilayaBadge, style: GoogleFonts.poppins(fontSize: 11, color: AppConstants.textTertiary)),
                  ]),
                ),
                const Icon(Icons.more_horiz, color: AppConstants.textTertiary),
              ],
            ),
          ),
          // Photo
          AspectRatio(
            aspectRatio: 1.0,
            child: post.photoUrl.isNotEmpty
                ? InteractiveViewer(
                    child: (post.photoUrl.startsWith('http') || post.photoUrl.startsWith('blob:'))
                        ? Image.network(post.photoUrl, fit: BoxFit.cover, width: double.infinity)
                        : Image.network(post.photoUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Icon(Icons.broken_image)),
                  )
                : Container(
                    color: AppConstants.backgroundElevated,
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          color: AppConstants.textTertiary, size: 40),
                    ),
                  ),
          ),
          // Actions/Caption
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => feed.toggleLike(post.id),
                      child: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, color: post.isLiked ? AppConstants.error : AppConstants.textPrimary, size: 26),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline, color: AppConstants.textPrimary, size: 24),
                    const Spacer(),
                    const Icon(Icons.bookmark_border, color: AppConstants.textPrimary, size: 26),
                  ],
                ),
                const SizedBox(height: 12),
                Text('${post.likes} likes', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: AppConstants.textPrimary)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.cairo(color: AppConstants.textPrimary, fontSize: 13),
                    children: [
                      TextSpan(text: '${post.username} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: post.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
