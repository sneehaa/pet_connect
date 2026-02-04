import 'package:flutter/material.dart';

import '../widgets/shared/empty_state.dart';

class NoQuestionnairePage extends StatelessWidget {
  final VoidCallback onStartQuestionnaire;
  final VoidCallback onRetry;
  final bool isLoading;

  const NoQuestionnairePage({
    super.key,
    required this.onStartQuestionnaire,
    required this.onRetry,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Compatibility'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : onRetry,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : EmptyState(
              title: 'No Questionnaire Found',
              message:
                  'Complete a lifestyle questionnaire to find pets that match your lifestyle and preferences.',
              icon: Icons.assignment,
              actionText: 'Start Questionnaire',
              action: onStartQuestionnaire,
            ),
    );
  }
}
