import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/core/utils/snackbar_utils.dart';
import 'package:pet_connect/features/business/business_dashboard/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/state/pet_state.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/add_edit_pet.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/view/adoption_requests_list.dart';
import 'package:pet_connect/features/business/business_dashboard/presentation/viewmodel/pet_view_model.dart';

class PetListScreen extends ConsumerStatefulWidget {
  const PetListScreen({super.key});

  @override
  ConsumerState<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends ConsumerState<PetListScreen> {
  final String businessId = "your_business_id"; // Get from auth state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petViewModelProvider.notifier).loadPets(businessId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PetState>(petViewModelProvider, (previous, next) {
      if (next.message != null) {
        showSnackBar(
          context: context,
          message: next.message!,
          isSuccess:
              !next.message!.contains('Failed') &&
              !next.message!.contains('error'),
        );
      }
    });

    final state = ref.watch(petViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        title: Text(
          'My Pets',
          style: AppStyles.headline2.copyWith(color: AppColors.textDarkGrey),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdoptionRequestsScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.list_alt,
              color: AppColors.primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: state.status == PetStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == PetStatus.error
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text('Failed to load pets', style: AppStyles.headline3),
                  Text(
                    state.message ?? 'Please try again',
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(petViewModelProvider.notifier)
                          .loadPets(businessId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Retry', style: AppStyles.button),
                  ),
                ],
              ),
            )
          : state.pets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, color: AppColors.primaryOrange, size: 80),
                  const SizedBox(height: 20),
                  Text('No Pets Added', style: AppStyles.headline3),
                  Text(
                    'Add your first pet to get started',
                    style: AppStyles.subtitle,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditPetScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryWhite,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text('Add Pet', style: AppStyles.button),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(petViewModelProvider.notifier)
                    .loadPets(businessId);
              },
              backgroundColor: AppColors.background,
              color: AppColors.primaryOrange,
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.pets.length,
                itemBuilder: (context, index) {
                  final pet = state.pets[index];
                  return _buildPetCard(pet, context);
                },
              ),
            ),
      floatingActionButton: state.pets.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditPetScreen()),
                );
              },
              backgroundColor: AppColors.primaryOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.add, color: AppColors.primaryWhite, size: 30),
            )
          : null,
    );
  }

  Widget _buildPetCard(PetEntity pet, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              image: pet.photos != null && pet.photos!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(pet.photos!.first),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: AssetImage('assets/images/default_pet.png'),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Stack(
              children: [
                // Status badge
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: pet.available
                          ? Colors.green.withOpacity(0.9)
                          : Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pet.available ? 'Available' : 'Adopted',
                      style: GoogleFonts.alice(
                        color: AppColors.primaryWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Pet Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pet.name, style: AppStyles.headline3),
                    Row(
                      children: [
                        Icon(
                          Icons.pets,
                          color: AppColors.primaryOrange,
                          size: 20,
                        ),
                        const SizedBox(width: 5),
                        Text('${pet.age} yrs', style: AppStyles.body),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: AppColors.textLightGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pet.breed,
                      style: AppStyles.body.copyWith(
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      pet.gender.toLowerCase() == 'male'
                          ? Icons.male
                          : Icons.female,
                      color: AppColors.textLightGrey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pet.gender,
                      style: AppStyles.body.copyWith(
                        color: AppColors.textDarkGrey,
                      ),
                    ),
                  ],
                ),
                if (pet.description != null && pet.description!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        pet.description!,
                        style: AppStyles.small,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                const SizedBox(height: 15),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditPetScreen(pet: pet),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryOrange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: Icon(
                          Icons.edit,
                          color: AppColors.primaryOrange,
                          size: 20,
                        ),
                        label: Text(
                          'Edit',
                          style: AppStyles.button.copyWith(
                            color: AppColors.primaryOrange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showPetActionsDialog(pet, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          'Manage',
                          style: AppStyles.button.copyWith(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPetActionsDialog(PetEntity pet, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text('Manage ${pet.name}', style: AppStyles.headline3),
              const SizedBox(height: 25),
              _buildActionTile(
                icon: Icons.switch_account,
                title: pet.available ? 'Mark as Adopted' : 'Mark as Available',
                color: AppColors.primaryOrange,
                onTap: () {
                  Navigator.pop(context);
                  ref
                      .read(petViewModelProvider.notifier)
                      .changeStatus(pet.id!, !pet.available);
                },
              ),
              _buildActionTile(
                icon: Icons.list_alt,
                title: 'View Adoption Requests',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdoptionRequestsScreen(petId: pet.id!),
                    ),
                  );
                },
              ),
              _buildActionTile(
                icon: Icons.delete,
                title: 'Delete Pet',
                color: AppColors.errorRed,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmationDialog(pet, context);
                },
              ),
              const SizedBox(height: 15),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.textLightGrey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'Cancel',
                  style: AppStyles.button.copyWith(
                    color: AppColors.textDarkGrey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: AppStyles.body.copyWith(fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: AppColors.textLightGrey),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  void _showDeleteConfirmationDialog(PetEntity pet, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: AppColors.errorRed, size: 28),
              const SizedBox(width: 12),
              Text('Delete Pet', style: AppStyles.headline3),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete ${pet.name}?',
                style: AppStyles.body,
              ),
              const SizedBox(height: 10),
              Text(
                'This action cannot be undone. All adoption requests for this pet will also be deleted.',
                style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppStyles.button.copyWith(color: AppColors.textDarkGrey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(petViewModelProvider.notifier).deletePet(pet.id!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Delete', style: AppStyles.button),
            ),
          ],
        );
      },
    );
  }
}
