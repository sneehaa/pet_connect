import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/features/user/compatibility/presentation/state/compatibility_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(compatibilityViewModelProvider.notifier).getCompatibilityAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compatibilityViewModelProvider);
    final viewModel = ref.read(compatibilityViewModelProvider.notifier);

    return LoadingOverlay(
      isLoading: state.status == CompatibilityStatus.loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Best Matches'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => viewModel.getCompatibilityAll(),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Questionnaire'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete Questionnaire'),
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.pushNamed(context, '/questionnaire');
                } else if (value == 'delete') {
                  _showDeleteDialog(context, viewModel);
                }
              },
            ),
          ],
        ),
        body: _buildBody(state, viewModel),
      ),
    );
  }

  Widget _buildBody(
    CompatibilityState state,
    CompatibilityViewModel viewModel,
  ) {
    if (state.status == CompatibilityStatus.error) {
      return ErrorDisplay(
        message: state.message ?? 'Failed to load results',
        onRetry: () => viewModel.getCompatibilityAll(),
      );
    }

    if (state.status == CompatibilityStatus.loaded &&
        state.compatibilityResults.isEmpty) {
      return EmptyState(
        title: 'No Pets Found',
        message:
            'There are no pets available for compatibility matching right now.',
        icon: Icons.pets,
      );
    }

    if (state.status == CompatibilityStatus.loaded) {
      return RefreshIndicator(
        onRefresh: () async {
          await viewModel.getCompatibilityAll();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.compatibilityResults.length,
          itemBuilder: (context, index) {
            final result = state.compatibilityResults[index];
            final pet = result.pet;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PetCompatibilityCard(
                score: result.score.compatibilityScore,
                pet: pet,
                breakdown: result.score.breakdown,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/pet-compatibility-detail',
                    arguments: result,
                  );
                },
              ),
            );
          },
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  void _showDeleteDialog(
    BuildContext context,
    CompatibilityViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Questionnaire'),
        content: const Text(
          'Are you sure you want to delete your questionnaire? '
          'This will reset your compatibility results.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteQuestionnaire();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
