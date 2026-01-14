import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/presentation/state/pet_state.dart';
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';

class BusinessPetsSection extends ConsumerWidget {
  final String businessId;

  const BusinessPetsSection({super.key, required this.businessId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petState = ref.watch(petViewModelProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Pets',
                  style: AppStyles.headline3.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${petState.pets.length} pets',
                  style: AppStyles.body.copyWith(
                    color: AppColors.textLightGrey,
                  ),
                ),
              ],
            ),
          ),
          if (petState.status == PetStatus.loading)
            _buildLoadingState()
          else if (petState.pets.isEmpty)
            _buildNoPetsAvailable()
          else
            _buildPetsList(petState.pets),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      ),
    );
  }

  Widget _buildNoPetsAvailable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: AppColors.textLightGrey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No pets available',
            style: AppStyles.body.copyWith(color: AppColors.textLightGrey),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new pets',
            style: AppStyles.small.copyWith(
              color: AppColors.textLightGrey.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(List<UserPetEntity> pets) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: pets.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, thickness: 1, color: AppColors.background),
      itemBuilder: (context, index) {
        final pet = pets[index];
        return _buildPetItem(pet);
      },
    );
  }

  Widget _buildPetItem(UserPetEntity pet) {
    return Container(
      color: Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to pet detail screen
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => PetDetailScreen(petId: pet.id),
            //   ),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.background,
                    image: pet.photos.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(pet.photos.first),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: pet.photos.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.pets,
                            size: 30,
                            color: AppColors.primaryOrange.withOpacity(0.3),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pet.name,
                            style: AppStyles.body.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: pet.available
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pet.available ? 'Available' : 'Adopted',
                              style: AppStyles.small.copyWith(
                                color: pet.available
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pet.breed} • ${pet.age} ${pet.age == 1 ? 'year' : 'years'} old • ${pet.gender}',
                        style: AppStyles.small.copyWith(
                          color: AppColors.textLightGrey,
                        ),
                      ),
                      if (pet.description != null &&
                          pet.description!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          pet.description!,
                          style: AppStyles.small.copyWith(
                            color: AppColors.textDarkGrey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      if (pet.vaccinated)
                        Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Vaccinated',
                              style: AppStyles.small.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textLightGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
