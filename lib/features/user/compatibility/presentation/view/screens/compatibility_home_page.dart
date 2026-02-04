import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/features/user/compatibility/presentation/state/compatibility_state.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/screens/questionnaire_page.dart';
import 'package:pet_connect/features/user/compatibility/presentation/viewmodel/compatibility_viewmodel.dart';

import 'compatibility_results_page.dart';
import 'no_questionnaire_page.dart';

class CompatibilityHomePage extends ConsumerStatefulWidget {
  const CompatibilityHomePage({super.key});

  @override
  ConsumerState<CompatibilityHomePage> createState() =>
      _CompatibilityHomePageState();
}

class _CompatibilityHomePageState extends ConsumerState<CompatibilityHomePage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Load questionnaire when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(compatibilityViewModelProvider.notifier).getQuestionnaire();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);
    final viewModel = ref.read(compatibilityViewModelProvider.notifier);

    // Check if we're loading for the first time
    if (!_isInitialized &&
        state.status == CompatibilityStatus.initial &&
        !state.isLoading) {
      return const _LoadingScreen();
    }

    // Set initialized flag after first load
    if (state.status != CompatibilityStatus.initial) {
      _isInitialized = true;
    }

    // Show loading screen
    if (state.isLoading && !_isInitialized) {
      return const _LoadingScreen();
    }

    // Check if questionnaire exists
    if (state.hasQuestionnaire) {
      return CompatibilityResultsPage(
        key: ValueKey('results-${state.questionnaire?.id}'),
      );
    } else {
      return NoQuestionnairePage(
        key: const ValueKey('no-questionnaire'),
        onStartQuestionnaire: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuestionnairePage()),
          );
        },
        onRetry: () {
          viewModel.getQuestionnaire();
        },
        isLoading: state.isLoading,
      );
    }
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pet Compatibility'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Checking your compatibility profile...',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
