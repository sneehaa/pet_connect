import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
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
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          ref.read(compatibilityViewModelProvider.notifier).getQuestionnaire(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: _buildCurrentView(state),
      ),
    );
  }

  Widget _buildCurrentView(CompatibilityState state) {
    if (state.isLoading && state.status == CompatibilityStatus.initial) {
      return const _LoadingScreen(key: ValueKey('loading'));
    }

    if (state.hasQuestionnaire) {
      return CompatibilityResultsPage(
        key: ValueKey('results-${state.questionnaire?.id}'),
      );
    }

    return NoQuestionnairePage(
      key: const ValueKey('no-questionnaire'),
      onStartQuestionnaire: () => _navigateToQuestionnaire(context),
      onRetry: () =>
          ref.read(compatibilityViewModelProvider.notifier).getQuestionnaire(),
      isLoading: state.isLoading,
    );
  }

  void _navigateToQuestionnaire(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnairePage(),
        fullscreenDialog: true,
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primaryOrange,
              ),
              backgroundColor: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Finding your perfect match...',
            style: AppStyles.headline3.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re analyzing pet personalities for you.',
            style: AppStyles.small,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
