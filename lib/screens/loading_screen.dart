import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/constants.dart';
import '../models/quiz_model.dart';

import '../services/ai_service.dart';
import 'itinerary_screen.dart';

class LoadingScreen extends StatefulWidget {
  final QuizAnswers quizAnswers;

  const LoadingScreen({super.key, required this.quizAnswers});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  final List<String> _messages = [
    'ALGORITHMS ARE SCOUTING...',
    'FINDING THE BEST TRAILS...',
    'CRAFTING YOUR EXPEDITION...',
    'ALMOST READY...',
  ];
  int _currentMessageIndex = 0;
  Timer? _messageTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _rotationController.repeat();

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentMessageIndex = (_currentMessageIndex + 1) % _messages.length;
        });
      }
    });

    _generateItinerary();
  }

  Future<void> _generateItinerary() async {
    try {
      final prompt = widget.quizAnswers.buildPrompt();
      final itinerary = await AiService.generateItinerary(
        userPrompt: prompt,
        days: widget.quizAnswers.days,
      );

      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ItineraryScreen(
              itinerary: itinerary,
              quizAnswers: widget.quizAnswers,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'A glitch occurred. Retrying...',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: AppConstants.error,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundDark,
      body: Stack(
        fit: StackFit.expand,
        children: [

          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppConstants.accentTeal.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      AnimatedBuilder(
                        animation: _rotationController,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationController.value * 6.28,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                  color: AppConstants.accentTeal.withValues(alpha: 0.2),
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    border: Border.all(
                                      color: AppConstants.accentTeal.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppConstants.accentTeal.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppConstants.accentTeal, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppConstants.accentTeal.withValues(alpha: 0.3),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 40,
                          color: AppConstants.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    _messages[_currentMessageIndex],
                    key: ValueKey<int>(_currentMessageIndex),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textPrimary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'RIHLA SMART AI',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.textTertiary,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 48),

                SizedBox(
                  width: 120,
                  height: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: AppConstants.backgroundElevated,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.accentTeal),
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
