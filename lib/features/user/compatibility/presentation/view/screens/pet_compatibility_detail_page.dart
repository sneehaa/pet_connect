import 'package:flutter/material.dart';
import 'package:pet_connect/config/themes/app_colors.dart';
import 'package:pet_connect/config/themes/app_styles.dart';
import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/widgets/results/explanation_card.dart';
import 'package:pet_connect/features/user/pets/presentation/view/pet_screen.dart';

import '../widgets/results/breakdown_chart.dart';
import '../widgets/results/compatibility_score_card.dart';

class PetCompatibilityDetailPage extends StatelessWidget {
  final CompatibilityResultEntity result;

  const PetCompatibilityDetailPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final pet = result.pet!;
    final score = result.score;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(pet),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompatibilityScoreCard(
                    score: score.compatibilityScore,
                    petName: pet.name,
                  ),
                  const SizedBox(height: 24),

                  Text('Why you match', style: AppStyles.headline3),
                  const SizedBox(height: 12),
                  ExplanationCard(explanation: score.explanation),
                  const SizedBox(height: 32),

                  Text('Match Analysis', style: AppStyles.headline3),
                  const SizedBox(height: 16),
                  BreakdownChart(breakdown: score.breakdown),
                  const SizedBox(height: 32),

                  _buildPetDetailsSection(pet),
                  const SizedBox(height: 40),

                  _buildPrimaryButton(context, pet),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(UserPetEntity pet) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primaryOrange,
      // Fixed: Back button color
      leading: const BackButton(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Text(
          pet.name,
          style: AppStyles.headline3.copyWith(color: Colors.white),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (pet.photos.isNotEmpty)
              Image.network(pet.photos.first, fit: BoxFit.cover)
            else
              Container(
                color: AppColors.primaryBlue,
                child: const Icon(Icons.pets, size: 100, color: Colors.white),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDetailsSection(UserPetEntity pet) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryOrange),
              const SizedBox(width: 8),
              Text(
                'Quick Facts',
                style: AppStyles.headline3.copyWith(fontSize: 18),
              ),
            ],
          ),
          const Divider(height: 32),
          _buildDetailGrid(pet),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(UserPetEntity pet) {
    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: [
        _buildDetailItem('Breed', pet.breed, Icons.category_outlined),
        _buildDetailItem('Age', '${pet.age} years', Icons.cake_outlined),
        _buildDetailItem('Gender', pet.gender, Icons.transgender_outlined),
        if (pet.personality != null)
          _buildDetailItem(
            'Trait',
            pet.personality!,
            Icons.psychology_outlined,
          ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return SizedBox(
      width: 140,
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textLightGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppStyles.small.copyWith(fontSize: 12)),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context, UserPetEntity pet) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primaryOrange, Color(0xFFFFB099)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOrange.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPetDetailScreen(petId: pet.id),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text('Meet ${pet.name}', style: AppStyles.button),
      ),
    );
  }
}
