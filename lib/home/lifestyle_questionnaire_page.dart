// lifestyle_questionnaire_page.dart
import 'package:flutter/material.dart';
import 'package:pet_connect/utils/constant.dart';


class LifestyleQuestionnairePage extends StatefulWidget {
  const LifestyleQuestionnairePage({Key? key}) : super(key: key);

  @override
  State<LifestyleQuestionnairePage> createState() => _LifestyleQuestionnairePageState();
}

class _LifestyleQuestionnairePageState extends State<LifestyleQuestionnairePage> {
  int _currentStep = 0;
  final List<String> _answers = List.filled(3, '');

  final List<Map<String, dynamic>> _questions = [
    {
      'question': '1. Where do you live?',
      'options': ['Apartment/Condo', 'House with a small yard', 'House with a large yard'],
    },
    {
      'question': '2. How active is your lifestyle?',
      'options': ['Low (Mostly home)', 'Medium (Daily walks)', 'High (Running/hiking)'],
    },
    {
      'question': '3. Do you have small children?',
      'options': ['Yes', 'No', 'Sometimes (Visits only)'],
    },
  ];

  void _nextStep() {
    if (_answers[_currentStep].isNotEmpty) {
      if (_currentStep < _questions.length - 1) {
        setState(() => _currentStep++);
      } else {
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option.')),
      );
    }
  }

  // Define the buildPrimaryButton function here or import it
  Widget buildPrimaryButton({required String text, required VoidCallback onPressed, bool isLoading = false, required BuildContext context}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 4,
        ),
        child: Text(text, style: kButtonStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCardColor,
      appBar: AppBar(
        title: Text('Lifestyle Quiz', style: kHeadlineStyle.copyWith(fontSize: 24)),
        backgroundColor: kCardColor,
        iconTheme: const IconThemeData(color: kTextColor),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Text('Question ${_currentStep + 1} of ${_questions.length}', style: kBodyStyle.copyWith(color: kSecondaryTextColor)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (_currentStep + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
              borderRadius: BorderRadius.circular(5),
              minHeight: 8,
            ),
            const SizedBox(height: 30),

            // Question
            Text(
              _questions[_currentStep]['question'],
              style: kTitleStyle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 20),

            // Options
            Expanded(
              child: ListView(
                children: (_questions[_currentStep]['options'] as List<String>).map((option) {
                  bool isSelected = _answers[_currentStep] == option;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                        child: Text(option, style: kBodyStyle.copyWith(color: isSelected ? Colors.white : kTextColor)),
                      ),
                      selected: isSelected,
                      selectedColor: kPrimaryColor,
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: isSelected ? kPrimaryColor : Colors.grey[300]!),
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          _answers[_currentStep] = selected ? option : '';
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Navigation Button
            buildPrimaryButton(
              context: context,
              text: _currentStep == _questions.length - 1 ? 'Calculate Compatibility' : 'Next Question',
              onPressed: _nextStep,
            ),
          ],
        ),
      ),
    );
  }
}