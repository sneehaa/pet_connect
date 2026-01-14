import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';
import 'package:pet_connect/features/user/pets/presentation/viewmodel/pet_viewmodel.dart';

class UserPetDetailScreen extends ConsumerStatefulWidget {
  final String petId;

  const UserPetDetailScreen({super.key, required this.petId});

  @override
  ConsumerState<UserPetDetailScreen> createState() =>
      _UserPetDetailScreenState();
}

class _UserPetDetailScreenState extends ConsumerState<UserPetDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petViewModelProvider.notifier).getPetById(widget.petId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(petViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: state.selectedPet != null && state.selectedPet!.id == widget.petId
          ? _buildPetDetail(state.selectedPet!)
          : state.isLoading
          ? _buildLoading()
          : _buildError(),
    );
  }

  Widget _buildLoading() {
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
            'Loading pet details...',
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

  Widget _buildError() {
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
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pet not found',
              style: AppStyles.headline3.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The pet you\'re looking for doesn\'t exist or has been removed',
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
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Go Back',
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

  Widget _buildPetDetail(UserPetEntity pet) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Pet photos
                if (pet.photos.isNotEmpty)
                  PageView.builder(
                    itemCount: pet.photos.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        pet.photos[index],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.textLightGrey,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                else
                  Container(
                    color: AppColors.textLightGrey,
                    child: Center(
                      child: Icon(
                        Icons.pets,
                        size: 100,
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ),

                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Available badge
                if (!pet.available)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Not Available',
                        style: AppStyles.small.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          pinned: true,
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pet name and basic info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: AppStyles.headline2.copyWith(fontSize: 28),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.pets,
                                size: 16,
                                color: AppColors.textLightGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pet.breed,
                                style: AppStyles.body.copyWith(
                                  color: AppColors.textLightGrey,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.cake,
                                size: 16,
                                color: AppColors.textLightGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${pet.age} ${pet.age == 1 ? 'month' : 'months'} old',
                                style: AppStyles.body.copyWith(
                                  color: AppColors.textLightGrey,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                pet.gender.toLowerCase() == 'male'
                                    ? Icons.male
                                    : Icons.female,
                                size: 16,
                                color: AppColors.textLightGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                pet.gender,
                                style: AppStyles.body.copyWith(
                                  color: AppColors.textLightGrey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (pet.vaccinated)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.medical_services,
                              size: 16,
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
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // Description
                if (pet.description != null && pet.description!.isNotEmpty) ...[
                  Text(
                    'About',
                    style: AppStyles.headline3.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.description!,
                    style: AppStyles.body.copyWith(
                      color: AppColors.textDarkGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Personality
                if (pet.personality != null && pet.personality!.isNotEmpty) ...[
                  Text(
                    'Personality',
                    style: AppStyles.headline3.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.personality!,
                    style: AppStyles.body.copyWith(
                      color: AppColors.textDarkGrey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Medical Info
                if (pet.medicalInfo != null && pet.medicalInfo!.isNotEmpty) ...[
                  Text(
                    'Medical Information',
                    style: AppStyles.headline3.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Text(
                      pet.medicalInfo!,
                      style: AppStyles.body.copyWith(
                        color: Colors.orange.shade800,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Additional Info
                Text(
                  'Additional Information',
                  style: AppStyles.headline3.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 12),

                // Info cards
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildInfoCard(
                      icon: Icons.business,
                      title: 'Business ID',
                      value: pet.businessId,
                    ),
                    _buildInfoCard(
                      icon: Icons.check_circle,
                      title: 'Status',
                      value: pet.available ? 'Available' : 'Not Available',
                      valueColor: pet.available ? Colors.green : Colors.red,
                    ),
                    if (pet.createdAt != null)
                      _buildInfoCard(
                        icon: Icons.calendar_today,
                        title: 'Listed On',
                        value: _formatDate(pet.createdAt!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = AppColors.textGrey,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textLightGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppStyles.small.copyWith(color: AppColors.textLightGrey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.body.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
