import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/provider/flutter_secure_storage.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/pet_state.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/add_edit_pet.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/adoption_requests_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/viewmodel/pet_view_model.dart';
import 'package:pet_connect/widgets/pet_widgets/delete_confirmatrion_dialogue.dart';
import 'package:pet_connect/widgets/pet_widgets/pet_actions_bottom_sheet.dart';
import 'package:pet_connect/widgets/pet_widgets/pet_card.dart';

class PetListScreen extends ConsumerStatefulWidget {
  const PetListScreen({super.key});

  @override
  ConsumerState<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends ConsumerState<PetListScreen> {
  String? _businessId;
  bool _isLoadingBusinessId = true;

  @override
  void initState() {
    super.initState();
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final secureStorage = ref.read(flutterSecureStorageProvider);
    final businessId = await secureStorage.read(key: 'businessId');

    if (mounted) {
      setState(() {
        _businessId = businessId;
        _isLoadingBusinessId = false;
      });

      if (_businessId != null) {
        ref.read(petViewModelProvider.notifier).loadPets(_businessId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while getting business ID
    if (_isLoadingBusinessId) {
      return _buildLoadingScreen();
    }

    // Show error if no business ID found
    if (_businessId == null) {
      return _buildBusinessErrorScreen();
    }

    // Now we have businessId, show the pet list
    return _buildPetListContent();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const CircularProgressIndicator(
                color: AppColors.primaryOrange,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading your pets...',
              style: AppStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDarkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessErrorScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business_outlined,
                  size: 50,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Business Not Found',
                style: AppStyles.headline3.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please login again to access your business dashboard',
                textAlign: TextAlign.center,
                style: AppStyles.small.copyWith(
                  fontSize: 14,
                  color: AppColors.textLightGrey,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/business-login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Go to Login',
                    style: AppStyles.button.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetListContent() {
    final state = ref.watch(petViewModelProvider);

    // Handle snackbar messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.message != null && state.message!.isNotEmpty) {
        showSnackBar(
          context: context,
          message: state.message!,
          isSuccess: state.status != PetStatus.error,
        );
        // Clear message after showing
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            ref.read(petViewModelProvider.notifier).state = state.copyWith(
              message: null,
            );
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.status == PetStatus.loading
          ? _buildLoadingPets()
          : state.status == PetStatus.error
          ? _buildErrorState(state)
          : state.pets.isEmpty
          ? _buildEmptyState()
          : _buildPetList(state),
      floatingActionButton: state.pets.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEditPetScreen(),
                  ),
                );
              },
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : null,
    );
  }

  Widget _buildLoadingPets() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              color: AppColors.primaryOrange,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading your pets...',
            style: AppStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDarkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(PetState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.error_outline, color: Colors.red, size: 50),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load pets',
              style: AppStyles.headline3.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              state.message ?? 'Please try again later',
              textAlign: TextAlign.center,
              style: AppStyles.small.copyWith(
                fontSize: 14,
                color: AppColors.textLightGrey,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  ref
                      .read(petViewModelProvider.notifier)
                      .loadPets(_businessId!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Retry',
                  style: AppStyles.button.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pets_outlined,
            color: AppColors.primaryOrange,
            size: 70,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'No Pets Added Yet',
          style: AppStyles.headline3.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Add your first pet to start managing adoptions for your business',
            textAlign: TextAlign.center,
            style: AppStyles.small.copyWith(
              fontSize: 14,
              color: AppColors.textLightGrey,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 220,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditPetScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            icon: const Icon(Icons.add, color: Colors.white, size: 22),
            label: Text(
              'Add Your First Pet',
              style: AppStyles.button.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetList(PetState state) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(petViewModelProvider.notifier)
                  .loadPets(_businessId!);
            },
            backgroundColor: AppColors.background,
            color: AppColors.primaryOrange,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              itemCount: state.pets.length,
              itemBuilder: (context, index) {
                final pet = state.pets[index];
                return PetCard(
                  pet: pet,
                  onEdit: () => _navigateToEditPet(pet),
                  onManage: () => _showPetActionsDialog(pet, context),
                  onDelete: () {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showPetActionsDialog(PetEntity pet, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return PetActionsBottomSheet(
          pet: pet,
          onToggleStatus: () {
            Navigator.pop(context);
            ref
                .read(petViewModelProvider.notifier)
                .changeStatus(pet.id!, !pet.available);
          },
          onViewAdoptionRequests: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdoptionRequestsScreen(petId: pet.id!),
              ),
            );
          },
          onDelete: () {
            Navigator.pop(context);
            _showDeleteConfirmationDialog(pet, context);
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(PetEntity pet, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteConfirmationDialog(
          pet: pet,
          onDelete: () {
            ref.read(petViewModelProvider.notifier).deletePet(pet.id!);
          },
        );
      },
    );
  }

  void _navigateToEditPet(PetEntity pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditPetScreen(pet: pet)),
    );
  }
}
