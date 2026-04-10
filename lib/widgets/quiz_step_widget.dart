import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../models/quiz_model.dart';

class QuizStepWidget extends StatelessWidget {
  final int step;

  const QuizStepWidget({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return _DestinationStep();
      case 1:
        return _DurationStep();
      case 2:
        return _TravelersStep();
      case 3:
        return _BudgetStep();
      case 4:
        return _InterestsStep();
      case 5:
        return _SpecialNeedsStep();
      case 6:
        return _GuideStep();
      default:
        return const SizedBox();
    }
  }
}

class _DestinationStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'WHERE ARE YOU\nHEADING?',
      questionAr: 'وين تحب تروح؟',
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppConstants.divider, width: 1.5),
              color: AppConstants.backgroundElevated,
            ),
            child: DropdownButtonFormField<String>(
              initialValue: quiz.answers.destination.isEmpty
                  ? null
                  : quiz.answers.destination,
              decoration: const InputDecoration(
                border: InputBorder.none,
                filled: false,
                prefixIcon: Icon(
                  Icons.location_on,
                  color: AppConstants.accentTeal,
                ),
              ),
              style: GoogleFonts.poppins(
                color: AppConstants.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: AppConstants.backgroundElevated,
              isExpanded: true,
              hint: Text(
                'Select Wilaya',
                style: GoogleFonts.poppins(color: AppConstants.textTertiary),
              ),
              items: AppConstants.allWilayas.map((wilaya) {
                final isSupported =
                    AppConstants.supportedWilayas.contains(wilaya);
                return DropdownMenuItem(
                  value: wilaya,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          wilaya,
                          style: GoogleFonts.cairo(
                            color: isSupported
                                ? AppConstants.textPrimary
                                : AppConstants.textTertiary,
                          ),
                        ),
                      ),
                      if (isSupported)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.accentTeal.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'LIVE',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppConstants.accentTeal,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  quiz.setDestination(value);
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          if (quiz.answers.destination.isNotEmpty &&
              !AppConstants.supportedWilayas
                  .contains(quiz.answers.destination))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.accentGold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppConstants.accentGold.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppConstants.accentGold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This wilaya is coming soon! Available now: Algiers & Bejaia.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppConstants.accentGold,
                      ),
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

class _DurationStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'HOW MANY DAYS\nFOR THIS JOURNEY?',
      questionAr: 'قداش نهار؟',
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppConstants.backgroundCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppConstants.divider),
            boxShadow: [
              BoxShadow(
                color: AppConstants.accentTeal.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${quiz.answers.days}',
                style: GoogleFonts.poppins(
                  fontSize: 100,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.accentTeal,
                  height: 1,
                  letterSpacing: -4,
                ),
              ),
              Text(
                quiz.answers.days == 1 ? 'DAY' : 'DAYS',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppConstants.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepperButton(
                    icon: Icons.remove,
                    onTap: quiz.answers.days > 1
                        ? () => quiz.setDays(quiz.answers.days - 1)
                        : null,
                  ),
                  const SizedBox(width: 48),
                  _StepperButton(
                    icon: Icons.add,
                    onTap: quiz.answers.days < 7
                        ? () => quiz.setDays(quiz.answers.days + 1)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return Material(
      color: isEnabled
          ? AppConstants.accentTeal
          : AppConstants.backgroundElevated,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isEnabled ? AppConstants.backgroundDark : AppConstants.textTertiary,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class _TravelersStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'WHO IS JOINING\nTHIS EXPEDITION?',
      questionAr: 'مع من تسافر؟',
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: AppConstants.travelerTypes.map((type) {
          final isSelected = quiz.answers.travelerType == type['label'] || 
                            quiz.answers.travelerType == type['id'];
          return _SelectableCard(
            icon: type['icon'] as IconData,
            label: type['label'] as String,
            isSelected: isSelected,
            onTap: () => quiz.setTravelerType(type['id'] as String),
          );
        }).toList(),
      ),
    );
  }
}

class _BudgetStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'SET YOUR\nBUDGET RANGE',
      questionAr: 'شو ميزانيتك؟',
      child: Column(
        children: AppConstants.budgetTypes.map((type) {
          final isSelected = quiz.answers.budget == type['label'] ||
                            quiz.answers.budget == type['id'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SelectableCard(
              icon: type['icon'] as IconData,
              label: type['label'] as String,
              isSelected: isSelected,
              onTap: () => quiz.setBudget(type['id'] as String),
              isHorizontal: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InterestsStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'WHAT SPARKED\nYOUR INTEREST?',
      questionAr: 'شو تحب؟',
      subtitle: 'SELECT MULTIPLE',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: AppConstants.interestTypes.map((type) {
          final isSelected = quiz.answers.interests.contains(type['label']) ||
                            quiz.answers.interests.contains(type['id']);
          return _InterestChip(
            icon: type['icon'] as IconData,
            label: type['label'] as String,
            isSelected: isSelected,
            onTap: () => quiz.toggleInterest(type['id'] as String),
          );
        }).toList(),
      ),
    );
  }
}

class _SpecialNeedsStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'ANY SPECIAL\nREQUIREMENTS?',
      questionAr: 'عندك احتياجات خاصة؟',
      subtitle: 'OPTIONAL STEP',
      child: Column(
        children: AppConstants.specialNeeds.map((need) {
          final isSelected = quiz.answers.specialNeeds.contains(need['label']) ||
                            quiz.answers.specialNeeds.contains(need['id']);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppConstants.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? AppConstants.accentTeal
                      : AppConstants.divider,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: SwitchListTile(
                title: Row(
                  children: [
                    Icon(
                      need['icon'] as IconData,
                      color: isSelected
                          ? AppConstants.accentTeal
                          : AppConstants.textTertiary,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      need['label'] as String,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppConstants.accentTeal
                            : AppConstants.textPrimary,
                      ),
                    ),
                  ],
                ),
                value: isSelected,
                onChanged: (_) =>
                    quiz.toggleSpecialNeed(need['id'] as String),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _QuizStepLayout extends StatelessWidget {
  final String question;
  final String questionAr;
  final String? subtitle;
  final Widget child;

  const _QuizStepLayout({
    required this.question,
    required this.questionAr,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            question,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppConstants.textPrimary,
              height: 1.1,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            questionAr,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppConstants.accentTeal,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppConstants.textTertiary,
                letterSpacing: 2,
              ),
            ),
          ],
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isHorizontal;

  const _SelectableCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(isHorizontal ? 20 : 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.accentTeal.withValues(alpha: 0.1)
              : AppConstants.backgroundCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.accentTeal
                : AppConstants.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isHorizontal
            ? Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.accentTeal.withValues(alpha: 0.1)
                          : AppConstants.backgroundElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? AppConstants.accentTeal
                          : AppConstants.textSecondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      label,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? AppConstants.accentTeal
                            : AppConstants.textPrimary,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle,
                        color: AppConstants.accentTeal, size: 24),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.accentTeal.withValues(alpha: 0.1)
                          : AppConstants.backgroundElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected
                          ? AppConstants.accentTeal
                          : AppConstants.textSecondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? AppConstants.accentTeal
                          : AppConstants.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _InterestChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.accentTeal : AppConstants.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppConstants.accentTeal
                : AppConstants.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppConstants.backgroundDark : AppConstants.accentGold,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppConstants.backgroundDark : AppConstants.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    return _QuizStepLayout(
      question: 'DO YOU WANT\nA GUIDE?',
      questionAr: 'تحب دليل سياحي؟',
      subtitle: 'OPTIONAL STEP',
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppConstants.backgroundCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: quiz.answers.wantsGuide
                    ? AppConstants.accentTeal
                    : AppConstants.divider,
                width: quiz.answers.wantsGuide ? 2 : 1,
              ),
            ),
            child: SwitchListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.explore,
                    color: quiz.answers.wantsGuide
                        ? AppConstants.accentTeal
                        : AppConstants.textTertiary,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Yes, I want a guide',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: quiz.answers.wantsGuide
                          ? AppConstants.accentTeal
                          : AppConstants.textPrimary,
                    ),
                  ),
                ],
              ),
              value: quiz.answers.wantsGuide,
              onChanged: (val) => quiz.setWantsGuide(val),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
