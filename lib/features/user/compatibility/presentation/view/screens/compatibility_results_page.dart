import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/compatibility/presentation/state/compatibility_state.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/screens/pet_compatibility_detail_page.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/screens/questionnaire_page.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/widgets/results/pet_compatibility_card.dart';
import 'package:pet_connect/features/user/compatibility/presentation/viewmodel/compatibility_viewmodel.dart';

import '../widgets/shared/empty_state.dart';
import '../widgets/shared/error_display.dart';
import '../widgets/shared/loading_overlay.dart';

class CompatibilityResultsPage extends ConsumerStatefulWidget {
  const CompatibilityResultsPage({super.key});

  @override
  ConsumerState<CompatibilityResultsPage> createState() =>
      _CompatibilityResultsPageState();
}

class _CompatibilityResultsPageState
    extends ConsumerState<CompatibilityResultsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(compatibilityViewModelProvider.notifier)
          .getCompatibilityAll(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);
    final viewModel = ref.read(compatibilityViewModelProvider.notifier);

    return LoadingOverlay(
      isLoading: state.status == CompatibilityStatus.loading,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primaryOrange,
              onRefresh: () => viewModel.getCompatibilityAll(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [_buildContent(state, viewModel)],
              ),
            ),
            if (state.status == CompatibilityStatus.loaded &&
                state.compatibilityResults.isNotEmpty)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: _buildFloatingActions(viewModel),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActions(CompatibilityViewModel viewModel) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.textBlack.withOpacity(0.9),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionPill(
              icon: Icons.edit_note_rounded,
              label: 'Edit Info',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionnairePage(),
                  ),
                );
              },
            ),
            Container(
              height: 24,
              width: 1,
              color: Colors.white24,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            _actionPill(
              icon: Icons.refresh_rounded,
              label: 'Reset',
              onTap: () => _showDeleteDialog(context, viewModel),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive ? AppColors.errorRed : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppStyles.button.copyWith(
                  color: isDestructive ? AppColors.errorRed : Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    CompatibilityState state,
    CompatibilityViewModel viewModel,
  ) {
    if (state.status == CompatibilityStatus.error) {
      return SliverFillRemaining(
        child: ErrorDisplay(
          message: state.message ?? 'Failed to load results',
          onRetry: () => viewModel.getCompatibilityAll(),
        ),
      );
    }

    if (state.status == CompatibilityStatus.loaded &&
        state.compatibilityResults.isEmpty) {
      return SliverFillRemaining(
        child: EmptyState(
          title: 'Finding your soul-pet...',
          message: 'Try adjusting your preferences to find more furry friends!',
          icon: Icons.pets_rounded,
          actionText: 'Adjust Preferences',
          action: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuestionnairePage(),
              ),
            );
          },
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 120),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final result = state.compatibilityResults[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 20),
            child: PetCompatibilityCard(
              score: result.score.compatibilityScore,
              pet: result.pet,
              breakdown: result.score.breakdown,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PetCompatibilityDetailPage(result: result),
                  ),
                );
              },
            ),
          );
        }, childCount: state.compatibilityResults.length),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    CompatibilityViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Start Over?', style: AppStyles.headline3),
        content: Text(
          'This will clear your current matches and reset your questionnaire.',
          style: AppStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Matches',
              style: AppStyles.body.copyWith(color: AppColors.textGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed.withOpacity(0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              viewModel.deleteQuestionnaire();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: AppStyles.body.copyWith(
                color: AppColors.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
