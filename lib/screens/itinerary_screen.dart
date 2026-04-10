import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/itinerary_model.dart';
import '../models/quiz_model.dart';
import '../widgets/day_card_widget.dart';
import '../widgets/booking_modal_widget.dart';
import '../services/whatsapp_service.dart';
import 'booking_confirmation_screen.dart';
import 'quiz_screen.dart';
import '../providers/journey_provider.dart';
import '../providers/navigation_provider.dart';
import '../services/guide_service.dart';
import '../models/place_model.dart';
import 'package:provider/provider.dart';

class ItineraryScreen extends StatefulWidget {
  final Itinerary itinerary;
  final QuizAnswers quizAnswers;

  const ItineraryScreen({
    super.key,
    required this.itinerary,
    required this.quizAnswers,
  });

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Notion-like checklist — tracks visited places as "dayNum_timeOfDay"
  final Set<String> _visitedPlaces = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.itinerary.days.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleVisited(String placeKey) {
    setState(() {
      if (_visitedPlaces.contains(placeKey)) {
        _visitedPlaces.remove(placeKey);
      } else {
        _visitedPlaces.add(placeKey);
      }
    });
  }

  int get _totalPlaces => widget.itinerary.days.length * 3;
  int get _visitedCount => _visitedPlaces.length;

  void _showBookingModal(String placeName, String category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingModalWidget(
        placeName: placeName,
        category: category,
        onConfirm: (booking) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  BookingConfirmationScreen(booking: booking),
            ),
          );
        },
      ),
    );
  }

  String get _travelerBadge {
    switch (widget.quizAnswers.travelerType) {
      case 'وحدي':
      case 'solo':
        return '👤 SOLO';
      case 'كابل':
      case 'couple':
        return '💑 COUPLE';
      case 'عيلة مع أطفال':
      case 'family':
        return '👨‍👩‍👧‍👦 FAMILY';
      case 'صحاب':
      case 'friends':
        return '👥 FRIENDS';
      default:
        return '🧳 EXPLORER';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasWild = widget.itinerary.hasWildPlaces;

    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 260,
              pinned: true,
              backgroundColor: AppConstants.backgroundDark,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Image.network(
                      'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?w=800&q=60',
                      fit: BoxFit.cover,
                    ),
                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            AppConstants.backgroundDark.withValues(alpha: 0.9),
                            AppConstants.backgroundDark,
                          ],
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      bottom: 80,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppConstants.accentTeal.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppConstants.accentTeal.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              'CUSTOM ITINERARY',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppConstants.accentTeal,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.itinerary.destination,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _infoBadge(Icons.calendar_today, '${widget.itinerary.days.length} DAYS'),
                              const SizedBox(width: 8),
                              _infoBadge(Icons.person, _travelerBadge),
                              const SizedBox(width: 8),
                              _infoBadge(Icons.wallet, widget.quizAnswers.budget.toUpperCase()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Progress bar
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _totalPlaces > 0 ? _visitedCount / _totalPlaces : 0,
                                    minHeight: 4,
                                    backgroundColor: AppConstants.backgroundElevated.withValues(alpha: 0.4),
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.accentTeal),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '$_visitedCount/$_totalPlaces',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.accentTeal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  width: double.infinity,
                  color: AppConstants.backgroundDark,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppConstants.accentTeal,
                    indicatorWeight: 3,
                    labelColor: AppConstants.accentTeal,
                    unselectedLabelColor: AppConstants.textTertiary,
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    tabs: widget.itinerary.days.map((day) {
                      return Tab(text: 'DAY ${day.day}');
                    }).toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.itinerary.days.map((day) {
                  return DayCardWidget(
                    day: day,
                    onBook: _showBookingModal,
                    visitedPlaces: _visitedPlaces,
                    onToggleVisited: _toggleVisited,
                  );
                }).toList(),
              ),
            ),
            if (widget.itinerary.wantsGuide)
              _buildGuideSection(context),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: AppConstants.backgroundCard,
          border: Border(top: BorderSide(color: AppConstants.divider.withValues(alpha: 0.5))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // START TRIP — only for WILD places
            if (hasWild)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<JourneyProvider>().startJourneyWithPlace(widget.itinerary.destination);
                      context.read<NavigationProvider>().setIndex(2);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.terrain, size: 24),
                    label: Text(
                      'START WILD TRIP',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () => WhatsAppService.shareItinerary(widget.itinerary),
                      icon: const Icon(Icons.share, size: 18),
                      label: Text(
                        'SHARE PLAN',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, letterSpacing: 1),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const QuizScreen()),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: Text(
                        'REPLAN',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, letterSpacing: 1),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.textSecondary,
                        side: BorderSide(color: AppConstants.divider),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.backgroundElevated.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppConstants.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppConstants.accentTeal, size: 12),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSection(BuildContext context) {
    return Container(
      color: AppConstants.backgroundDark,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: FutureBuilder<List<Guide>>(
        future: GuideService().getAllGuides(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final guides = snapshot.data!;
          if (guides.isEmpty) return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AVAILABLE GUIDES FOR YOUR TRIP',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppConstants.accentTeal,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: guides.length,
                  itemBuilder: (context, index) {
                    final g = guides[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppConstants.backgroundCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppConstants.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g.name, style: GoogleFonts.cairo(fontWeight: FontWeight.w700, fontSize: 16, color: AppConstants.textPrimary)),
                          Text('⭐ ${g.rating} - ${g.languages.join(", ")}', style: GoogleFonts.cairo(fontSize: 12, color: AppConstants.textSecondary)),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.accentTeal.withValues(alpha: 0.1),
                                foregroundColor: AppConstants.accentTeal,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                _showBookingModal(g.name, "guide");
                              },
                              child: Text('Book Guide', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 12)),
                            ),
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
    );
  }
}
