import 'package:flutter/material.dart';
import 'package:pet_connect/features/user/compatibility/domain/entity/compatibility_entity.dart';
import 'package:pet_connect/features/user/compatibility/presentation/view/widgets/results/explanation_card.dart';

import '../widgets/results/breakdown_chart.dart';
import '../widgets/results/compatibility_score_card.dart';

class PetCompatibilityDetailPage extends StatelessWidget {
  const PetCompatibilityDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final result =
        ModalRoute.of(context)?.settings.arguments as CompatibilityResultEntity;

    final pet = result.pet!;
    final score = result.score;

    return Scaffold(
      appBar: AppBar(title: Text(pet.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image
            if (pet.photos.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(pet.photos.first),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.pets, size: 80, color: Colors.grey),
              ),
            const SizedBox(height: 24),

            // Compatibility Score
            CompatibilityScoreCard(
              score: score.compatibilityScore,
              petName: pet.name,
            ),
            const SizedBox(height: 24),

            // Explanation
            ExplanationCard(explanation: score.explanation),
            const SizedBox(height: 24),

            // Breakdown
            BreakdownChart(breakdown: score.breakdown),
            const SizedBox(height: 24),

            // Pet Details
            _buildPetDetails(pet),
            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/pet-detail',
                    arguments: pet.id,
                  );
                },
                child: const Text('View Pet Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDetails(UserPetEntity pet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pet Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Name', pet.name),
          _buildDetailRow('Breed', pet.breed),
          _buildDetailRow('Age', '${pet.age} years'),
          _buildDetailRow('Gender', pet.gender),
          if (pet.personality?.isNotEmpty == true)
            _buildDetailRow('Personality', pet.personality!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
