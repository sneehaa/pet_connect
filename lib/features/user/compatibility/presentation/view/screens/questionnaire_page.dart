import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/screens/compatibility_home_page.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/screens/compatibility_results_page.dart';
import 'package:pet_connect/features/user/compatibility/presentation/viewmodel/compatibility_viewmodel.dart';

import '../widgets/questionnaire/activity_level_question.dart';
import '../widgets/questionnaire/boolean_question.dart';
import '../widgets/questionnaire/energy_preference_question.dart';
import '../widgets/questionnaire/household_question.dart';
import '../widgets/questionnaire/living_space_question.dart';
import '../widgets/questionnaire/noise_tolerance_question.dart';
import '../widgets/questionnaire/pet_experience_question.dart';
import '../widgets/questionnaire/questionnaire_progress.dart';
import '../widgets/questionnaire/time_commitment_question.dart';
import '../widgets/questionnaire/work_schedule_question.dart';
import '../widgets/shared/loading_overlay.dart';

class QuestionnairePage extends ConsumerStatefulWidget {
  const QuestionnairePage({super.key});

  @override
  ConsumerState<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends ConsumerState<QuestionnairePage> {
  final PageController _pageController = PageController();
  final Map<String, dynamic> _formData = {};
  int _currentPage = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'Living Space',
      'subtitle': 'Tell us about your home environment',
      'key': 'livingSpace',
      'widget': (val, onChg) =>
          LivingSpaceQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Activity Level',
      'subtitle': 'How active is your daily routine?',
      'key': 'activityLevel',
      'widget': (val, onChg) =>
          ActivityLevelQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Work Schedule',
      'subtitle': 'How much time do you spend at home?',
      'key': 'workSchedule',
      'widget': (val, onChg) =>
          WorkScheduleQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Pet Experience',
      'subtitle': 'Have you owned pets before?',
      'key': 'petExperience',
      'widget': (val, onChg) =>
          PetExperienceQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Household',
      'subtitle': 'Who else lives in your home?',
      'key': 'household',
      'widget': (val, onChg) =>
          HouseholdQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Energy Preference',
      'subtitle': 'What kind of energy are you looking for?',
      'key': 'preferredEnergy',
      'widget': (val, onChg) =>
          EnergyPreferenceQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Time Commitment',
      'subtitle': 'Daily time dedicated to pet care',
      'key': 'timeForPet',
      'widget': (val, onChg) =>
          TimeCommitmentQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Noise Tolerance',
      'subtitle': 'How do you feel about a vocal pet?',
      'key': 'noiseTolerance',
      'widget': (val, onChg) =>
          NoiseToleranceQuestion(selectedValue: val, onChanged: onChg),
    },
    {
      'title': 'Yard Access',
      'subtitle': 'Outdoor space availability',
      'key': 'hasYard',
      'widget': (val, onChg) => BooleanQuestion(
        question: 'Do you have access to a yard or outdoor space?',
        value: val,
        onChanged: onChg,
      ),
    },
    {
      'title': 'Allergies',
      'subtitle': 'Health considerations',
      'key': 'hasAllergies',
      'widget': (val, onChg) => BooleanQuestion(
        question: 'Do you or anyone in your household have pet allergies?',
        value: val,
        onChanged: onChg,
      ),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAnswer(String key, dynamic value) {
    setState(() => _formData[key] = value);
    // Auto-advance for a smoother feel on selection-based questions
    Future.delayed(const Duration(milliseconds: 300), _nextPage);
  }

  void _nextPage() {
    final key = _questions[_currentPage]['key'] as String;
    if (_formData[key] == null) return;

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      setState(() => _currentPage++);
    } else {
      _submitQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
      setState(() => _currentPage--);
    }
  }

  void _submitQuestionnaire() async {
    final viewModel = ref.read(compatibilityViewModelProvider.notifier);

    await viewModel.submitQuestionnaire(_formData);

    if (mounted) {
      final state = ref.read(compatibilityViewModelProvider);

      if (state.compatibilityResults.isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const CompatibilityHomePage(),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const CompatibilityResultsPage(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textBlack),
            onPressed: () => Navigator.pop(context),
          ),
          title: QuestionnaireProgress(
            currentStep: _currentPage + 1,
            totalSteps: _questions.length,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) => _buildQuestionStep(index),
              ),
            ),
            _buildNavigationFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionStep(int index) {
    final question = _questions[index];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question['title'], style: AppStyles.headline2),
          const SizedBox(height: 8),
          Text(question['subtitle'], style: AppStyles.subtitle),
          const SizedBox(height: 40),
          Expanded(
            child: question['widget'](
              _formData[question['key']],
              (val) => _handleAnswer(question['key'], val),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationFooter() {
    final isLast = _currentPage == _questions.length - 1;
    final hasAnswered = _formData[_questions[_currentPage]['key']] != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _previousPage,
              child: Text(
                'Back',
                style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
              ),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton(
            onPressed: hasAnswered ? _nextPage : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast
                  ? AppColors.successGreen
                  : AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              isLast ? 'See Results' : 'Next Question',
              style: AppStyles.button.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
