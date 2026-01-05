// compatibility_widget.dart
import 'package:flutter/material.dart';
import 'package:pet_connect/home/lifestyle_questionnaire_page.dart';
import 'package:pet_connect/utils/constant.dart';


class CompatibilityWidget extends StatefulWidget {
  final String petName;
  const CompatibilityWidget({Key? key, required this.petName}) : super(key: key);

  @override
  State<CompatibilityWidget> createState() => _CompatibilityWidgetState();
}

class _CompatibilityWidgetState extends State<CompatibilityWidget> {
  int _compatibilityScore = 0;
  String? _explanationText;

  void _calculateScore(BuildContext context) async {
    final bool? completed = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LifestyleQuestionnairePage()),
    );

    if (completed == true && mounted) {
      setState(() {
        _compatibilityScore = 85;
        _explanationText = 'This pet suits you because you prefer calm pets and live in an apartment. ${widget.petName} is a low-energy companion!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_compatibilityScore > 0) {
      // Display Score
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your Match Score', style: kTitleStyle),
                Text(
                  '${_compatibilityScore}%',
                  style: kHeadlineStyle.copyWith(color: kPrimaryColor, fontSize: 36),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _explanationText!,
              style: kBodyStyle.copyWith(fontSize: 14, color: kSecondaryTextColor),
            ),
          ],
        ),
      );
    } else {
      // Prompt to take questionnaire
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.psychology, color: kPrimaryColor, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Check compatibility with ${widget.petName}!', style: kBodyStyle.copyWith(fontSize: 15)),
            ),
            TextButton(
              onPressed: () => _calculateScore(context),
              child: Text('Start Quiz', style: kBodyStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }
  }
}