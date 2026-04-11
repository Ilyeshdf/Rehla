import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../../models/journey_model.dart';
import '../../models/post_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/feed_provider.dart';
import '../../widgets/adaptive_image.dart';
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
          'WINNER CARD',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 2, color: AppConstants.accentGold),
        ),
        actions: [
          if (_isPublishing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.accentTeal)),
            )
          else
            TextButton(
              onPressed: _publishPost,
              child: Text(
                'SHARE PATH',
                style: GoogleFonts.poppins(color: AppConstants.accentTeal, fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Winner Card Preview
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppConstants.accentGold.withValues(alpha: 0.3), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.accentGold.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: widget.journey.photos.isNotEmpty
                          ? AdaptiveImage(imagePath: widget.journey.photos.first, fit: BoxFit.cover)
                          : Container(color: AppConstants.backgroundElevated),
                    ),
                    // Gold Overlay
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.accentGold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.stars, color: AppConstants.backgroundDark, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'WINNER',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 10, color: AppConstants.backgroundDark),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Stats bar at bottom of image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        color: Colors.black54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildImageStat(Icons.route, '${widget.journey.distanceKm.toStringAsFixed(1)}km'),
                            _buildImageStat(Icons.timer, '${widget.journey.duration.inMinutes}min'),
                            _buildImageStat(Icons.terrain, widget.journey.difficulty),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'PERSONALIZED STORY (POWERED BY GROK)',
                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w800, color: AppConstants.accentTeal, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _captionController,
                    maxLines: 4,
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Describe your achievement...',
                      hintStyle: GoogleFonts.cairo(color: AppConstants.textTertiary),
                      filled: true,
                      fillColor: AppConstants.backgroundCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppConstants.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: AppConstants.divider),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isGeneratingAI ? null : _generateAICaption,
                      icon: _isGeneratingAI 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.auto_awesome, size: 20),
                      label: Text(
                        'AI GENERATE ACHIEVEMENT STORY',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.accentTeal.withValues(alpha: 0.1),
                        foregroundColor: AppConstants.accentTeal,
                        side: BorderSide(color: AppConstants.accentTeal.withValues(alpha: 0.4)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'By sharing this path, you save data for future explorers of the Mediterranean Horizon.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 11, color: AppConstants.textTertiary, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStat(IconData icon, String val) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 4),
        Text(val, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }

  Future<void> _generateAICaption() async {
    setState(() => _isGeneratingAI = true);
    
    try {
      final response = await http.post(
        Uri.parse(AppConstants.groqApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConstants.groqApiKey}',
        },
        body: jsonEncode({
          'model': AppConstants.groqModel,
          'messages': [
            {
              'role': 'system',
              'content': 'You are the Mediterranean Horizon AI Assistant, designed by architect Haddef Mohamed Ilyes. Highlight the user achievement in Algeria. Keep it inspiring and short (2 sentences max). Use Arabic emojis.'
            },
            {
              'role': 'user',
              'content': 'User hiked ${widget.journey.distanceKm.toStringAsFixed(1)}km in ${widget.journey.placeName}. Generate an achievement caption.'
            }
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final content = decoded['choices'][0]['message']['content'];
        setState(() {
          _captionController.text = content.trim();
        });
      }
    } catch (e) {
      setState(() {
        _captionController.text = "مغامرة مذهلة في ${widget.journey.placeName}! ⛰️🇩🇿 قطعنا مسافة مميزة وتجاوزنا التحديات.";
      } );
    } finally {
      setState(() => _isGeneratingAI = false);
    }
  }

  void _publishPost() async {
    if (_isPublishing) return;
    setState(() => _isPublishing = true);

    final userProvider = context.read<UserProvider>();
    final user = userProvider.currentUser!;

    final newPost = PostModel(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      userId: user.id,
      username: user.username,
      wilayaBadge: user.wilaya,
      journeyId: widget.journey.id,
      photoUrl: widget.journey.photos.isNotEmpty ? widget.journey.photos.first : '',
      caption: _captionController.text,
      tags: ['#WinnerCard', '#رحلة', '#الجزائر'],
      createdAt: DateTime.now(),
      distanceKm: widget.journey.distanceKm,
      time: widget.journey.duration,
      difficulty: widget.journey.difficulty,
    );

    await context.read<FeedProvider>().addPost(newPost);
    final newlyUnlocked = await userProvider.addXp(200); // Winner card bonus

    if (mounted) {
      setState(() => _isPublishing = false);
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

