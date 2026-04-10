import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/quiz_model.dart';
import '../widgets/progress_bar_widget.dart';
import '../widgets/quiz_step_widget.dart';
import 'loading_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, quiz, _) {
        return Scaffold(
          backgroundColor: AppConstants.backgroundDark,
          appBar: AppBar(
            backgroundColor: AppConstants.backgroundCard,
            elevation: 0,
            leading: quiz.currentStep > 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => quiz.previousStep(),
                  )
                : IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      quiz.reset();
                      Navigator.of(context).pop();
                    },
                  ),
            title: Text(
              'PLAN YOUR JOURNEY',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppConstants.textPrimary,
                letterSpacing: 2,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: ProgressBarWidget(
                currentStep: quiz.currentStep,
                totalSteps: 7,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: QuizStepWidget(
                    key: ValueKey<int>(quiz.currentStep),
                    step: quiz.currentStep,
                  ),
                ),
              ),

              // Bottom buttons
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundCard,
                  border: Border(
                    top: BorderSide(color: AppConstants.divider.withValues(alpha: 0.5)),
                  ),
                ),
                child: Row(
                  children: [
                    if (quiz.currentStep == 6)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _navigateToLoading(context, quiz),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.textSecondary,
                            side: BorderSide(color: AppConstants.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'SKIP',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    if (quiz.currentStep == 6) const SizedBox(width: 16),
                    Expanded(
                      flex: quiz.currentStep == 6 ? 2 : 1,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: quiz.isStepValid
                              ? () {
                                  if (quiz.currentStep < 6) {
                                    quiz.nextStep();
                                  } else {
                                    _navigateToLoading(context, quiz);
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.accentTeal,
                            foregroundColor: AppConstants.backgroundDark,
                            disabledBackgroundColor:
                                AppConstants.accentTeal.withValues(alpha: 0.1),
                            disabledForegroundColor:
                                AppConstants.textTertiary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                quiz.currentStep < 6 ? 'NEXT STEP' : 'REVEAL JOURNEY',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToLoading(BuildContext context, QuizProvider quiz) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadingScreen(
          quizAnswers: quiz.answers,
        ),
      ),
    );
  }
}
