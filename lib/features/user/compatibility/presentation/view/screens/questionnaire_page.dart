import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      'key': 'livingSpace',
      'widget': (selectedValue, onChanged) => LivingSpaceQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Activity Level',
      'key': 'activityLevel',
      'widget': (selectedValue, onChanged) => ActivityLevelQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Work Schedule',
      'key': 'workSchedule',
      'widget': (selectedValue, onChanged) => WorkScheduleQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Pet Experience',
      'key': 'petExperience',
      'widget': (selectedValue, onChanged) => PetExperienceQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Household',
      'key': 'household',
      'widget': (selectedValue, onChanged) =>
          HouseholdQuestion(selectedValue: selectedValue, onChanged: onChanged),
    },
    {
      'title': 'Energy Preference',
      'key': 'preferredEnergy',
      'widget': (selectedValue, onChanged) => EnergyPreferenceQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Time Commitment',
      'key': 'timeForPet',
      'widget': (selectedValue, onChanged) => TimeCommitmentQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Noise Tolerance',
      'key': 'noiseTolerance',
      'widget': (selectedValue, onChanged) => NoiseToleranceQuestion(
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Yard Access',
      'key': 'hasYard',
      'widget': (selectedValue, onChanged) => BooleanQuestion(
        question: 'Do you have access to a yard or outdoor space?',
        value: selectedValue,
        onChanged: onChanged,
      ),
    },
    {
      'title': 'Allergies',
      'key': 'hasAllergies',
      'widget': (selectedValue, onChanged) => BooleanQuestion(
        question: 'Do you or anyone in your household have pet allergies?',
        value: selectedValue,
        onChanged: onChanged,
      ),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAnswer(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
  }

  void _nextPage() {
    final currentQuestion = _questions[_currentPage];
    final key = currentQuestion['key'] as String;

    if (_formData[key] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer this question before continuing'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    } else {
      _submitQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage--;
      });
    }
  }

  void _submitQuestionnaire() {
    final viewModel = ref.read(compatibilityViewModelProvider.notifier);

    viewModel.submitQuestionnaire(_formData).then((_) {
      final state = ref.read(compatibilityViewModelProvider);

      if (state.message?.contains('success') == true || state.message == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Questionnaire saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/compatibility-results',
          (route) => false,
        );
      } else if (state.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!), backgroundColor: Colors.red),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);

    return LoadingOverlay(
      isLoading: state.isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lifestyle Questionnaire'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Icon(Icons.assignment, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Answer all questions to find your perfect pet match',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    QuestionnaireProgress(
                      currentStep: _currentPage + 1,
                      totalSteps: _questions.length,
                      onBack: _currentPage > 0 ? _previousPage : null,
                      onNext: _nextPage,
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final question = _questions[index];
                          final key = question['key'] as String;
                          final widgetBuilder =
                              question['widget']
                                  as Widget Function(
                                    dynamic,
                                    Function(dynamic),
                                  );

                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                widgetBuilder(_formData[key], (value) {
                                  _handleAnswer(key, value);
                                }),
                                const SizedBox(height: 32),
                                if (index == _questions.length - 1)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green[100]!,
                                      ),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'You\'re almost done! Submit to see your pet matches.',
                                            style: TextStyle(
                                              color: Colors.green,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
