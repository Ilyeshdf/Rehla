import 'package:flutter/material.dart';
import '../config/constants.dart';

class QuizAnswers {
  String destination;
  int days;
  String travelerType;
  String budget;
  List<String> interests;
  List<String> specialNeeds;
  bool wantsGuide;
  String? selectedGuideId;

  QuizAnswers({
    this.destination = '',
    this.days = 3,
    this.travelerType = '',
    this.budget = '',
    this.wantsGuide = false,
    this.selectedGuideId,
    List<String>? interests,
    List<String>? specialNeeds,
  })  : interests = interests ?? [],
        specialNeeds = specialNeeds ?? [];

  String buildPrompt() {

    final travelerLabel = AppConstants.travelerTypes
        .firstWhere((t) => t['id'] == travelerType, orElse: () => {'label': travelerType})['label'];
    final budgetLabel = AppConstants.budgetTypes
        .firstWhere((b) => b['id'] == budget, orElse: () => {'label': budget})['label'];
    final interestsLabels = interests.map((id) => AppConstants.interestTypes
        .firstWhere((i) => i['id'] == id, orElse: () => {'label': id})['label']).join('، ');

    return 'أنا أريد التخطيط لرحلة إلى $destination لمدة $days أيام. المسافرون: $travelerLabel. الميزانية: $budgetLabel. الاهتمامات: $interestsLabels.';
  }

  QuizAnswers copyWith({
    String? destination,
    int? days,
    String? travelerType,
    String? budget,
    bool? wantsGuide,
    String? selectedGuideId,
    List<String>? interests,
    List<String>? specialNeeds,
  }) {
    return QuizAnswers(
      destination: destination ?? this.destination,
      days: days ?? this.days,
      travelerType: travelerType ?? this.travelerType,
      budget: budget ?? this.budget,
      wantsGuide: wantsGuide ?? this.wantsGuide,
      selectedGuideId: selectedGuideId ?? this.selectedGuideId,
      interests: interests ?? List.from(this.interests),
      specialNeeds: specialNeeds ?? List.from(this.specialNeeds),
    );
  }
}

class QuizProvider extends ChangeNotifier {
  QuizAnswers _answers = QuizAnswers();
  int _currentStep = 0;

  QuizAnswers get answers => _answers;
  int get currentStep => _currentStep;

  void setDestination(String destination) {
    _answers.destination = destination;
    notifyListeners();
  }

  void setDays(int days) {
    _answers.days = days;
    notifyListeners();
  }

  void setTravelerType(String type) {
    _answers.travelerType = type;
    notifyListeners();
  }

  void setBudget(String budget) {
    _answers.budget = budget;
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (_answers.interests.contains(interest)) {
      _answers.interests.remove(interest);
    } else {
      _answers.interests.add(interest);
    }
    notifyListeners();
  }

  void toggleSpecialNeed(String need) {
    if (_answers.specialNeeds.contains(need)) {
      _answers.specialNeeds.remove(need);
    } else {
      _answers.specialNeeds.add(need);
    }
    notifyListeners();
  }

  void setWantsGuide(bool wants) {
    _answers.wantsGuide = wants;
    if (!wants) _answers.selectedGuideId = null;
    notifyListeners();
  }

  void setSelectedGuideId(String? id) {
    _answers.selectedGuideId = id;
    if (id != null) _answers.wantsGuide = true;
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep < 6) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    _answers = QuizAnswers();
    _currentStep = 0;
    notifyListeners();
  }

  bool get isStepValid {
    switch (_currentStep) {
      case 0:
        return _answers.destination.isNotEmpty;
      case 1:
        return _answers.days >= 1 && _answers.days <= 7;
      case 2:
        return _answers.travelerType.isNotEmpty;
      case 3:
        return _answers.budget.isNotEmpty;
      case 4:
        return _answers.interests.isNotEmpty;
      case 5:
        return true; 
      case 6:
        return true; 
      default:
        return false;
    }
  }
}
