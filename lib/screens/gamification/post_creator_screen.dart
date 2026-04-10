import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../config/constants.dart';
import '../../models/journey_model.dart';
import '../../models/post_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/feed_provider.dart';
import 'achievement_unlock_screen.dart';

class PostCreatorScreen extends StatefulWidget {
  final JourneyModel journey;

  const PostCreatorScreen({super.key, required this.journey});

  @override
  State<PostCreatorScreen> createState() => _PostCreatorScreenState();
}

class _PostCreatorScreenState extends State<PostCreatorScreen> {
  late TextEditingController _captionController;
  bool _isGeneratingAI = false;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    final defaultCaption = "استكشفت ${widget.journey.placeName} اليوم! ⛰️🇩🇿";
    _captionController = TextEditingController(text: defaultCaption);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppConstants.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'NEW POST',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.5),
        ),
        actions: [
          if (_isPublishing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _publishPost,
              child: Text(
                'SHARE',
                style: GoogleFonts.poppins(color: AppConstants.accentTeal, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Instagram-style Square Preview
            AspectRatio(
              aspectRatio: 1,
              child: widget.journey.photos.isNotEmpty
                  ? (kIsWeb || widget.journey.photos.first.startsWith('http') || widget.journey.photos.first.startsWith('blob:'))
                      ? Image.network(widget.journey.photos.first, fit: BoxFit.cover)
                      : Image.network(widget.journey.photos.first, fit: BoxFit.cover) // Fallback for web
                  : Container(color: AppConstants.backgroundElevated),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'CAPTION',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w700, color: AppConstants.textTertiary, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _captionController,
                    maxLines: 4,
                    style: GoogleFonts.cairo(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'اكتب شيئاً عن مغامرتك...',
                      hintStyle: GoogleFonts.cairo(color: AppConstants.textTertiary),
                      filled: true,
                      fillColor: AppConstants.backgroundCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // AI Button
                  InkWell(
                    onTap: _generateAICaption,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.accentTeal.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppConstants.accentTeal.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _isGeneratingAI 
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.auto_awesome, color: AppConstants.accentTeal, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'AI ENHANCE CAPTION',
                            style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, color: AppConstants.accentTeal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Journey Stats
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.backgroundCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             _buildMiniStat(Icons.route_outlined, '${widget.journey.distanceKm.toStringAsFixed(1)} KM'),
                             _buildMiniStat(Icons.timer_outlined, '${widget.journey.duration.inMinutes} MIN'),
                             _buildMiniStat(Icons.terrain_outlined, widget.journey.difficulty),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String val) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.accentGold, size: 16),
        const SizedBox(width: 8),
        Text(val, style: GoogleFonts.poppins(color: AppConstants.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }

  void _generateAICaption() {
    setState(() => _isGeneratingAI = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _captionController.text = "مغامرة لا تُنسى في ${widget.journey.placeName}! ⛰️🇩🇿 الطبيعة الجزائرية تبهرني كل مرة. #اكتشف_الجزائر";
        _isGeneratingAI = false;
      });
    });
  }

  void _publishPost() async {
    if (_isPublishing) return;
    setState(() => _isPublishing = true);

    final userProvider = context.read<UserProvider>();
    final user = userProvider.currentUser!;
    
    // Create post
    final newPost = PostModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.id,
      username: user.username,
      wilayaBadge: user.wilaya,
      journeyId: widget.journey.id,
      photoUrl: widget.journey.photos.isNotEmpty ? widget.journey.photos.first : '',
      caption: _captionController.text,
      tags: ['#رحلة', '#الجزائر'],
      createdAt: DateTime.now(),
      distanceKm: widget.journey.distanceKm,
      time: widget.journey.duration,
      difficulty: widget.journey.difficulty,
    );
    
    // Save post
    await context.read<FeedProvider>().addPost(newPost);
    
    // Add XP and check for achievements
    final newlyUnlocked = await userProvider.addXp(150); // Base XP for posting
    
    if (mounted) {
      setState(() => _isPublishing = false);
      
      // Navigate to the reward screen (even if no achievement, it shows the XP gain)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => AchievementUnlockScreen(
            journey: widget.journey,
            unlockedAchievements: newlyUnlocked,
          ),
        ),
      );
    }
  }
}
