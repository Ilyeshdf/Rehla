import 'package:flutter/material.dart';
import '../config/constants.dart';

class ProgressBarWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressBarWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: LinearProgressIndicator(
            value: (currentStep + 1) / totalSteps,
            minHeight: 4,
            backgroundColor: AppConstants.backgroundDark,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.accentTeal,
            ),
          ),
        ),
      ],
    );
  }
}
