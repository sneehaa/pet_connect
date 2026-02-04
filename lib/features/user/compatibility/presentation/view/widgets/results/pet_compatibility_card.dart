import 'package:flutter/material.dart';
import 'package:pet_connect/features/user/pets/domain/entity/pet_entity.dart';

class PetCompatibilityCard extends StatelessWidget {
  final int score;
  final UserPetEntity? pet;
  final Map<String, dynamic> breakdown;
  final VoidCallback onTap;

  const PetCompatibilityCard({
    super.key,
    required this.score,
    this.pet,
    required this.breakdown,
    required this.onTap,
  });

  Color _getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreText() {
    if (score >= 80) return 'Excellent Match';
    if (score >= 60) return 'Good Match';
    if (score >= 40) return 'Fair Match';
    return 'Poor Match';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Pet Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: pet?.photos.isNotEmpty == true
                      ? DecorationImage(
                          image: NetworkImage(pet!.photos.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey[200],
                ),
                child: pet?.photos.isEmpty == true
                    ? const Center(
                        child: Icon(Icons.pets, size: 40, color: Colors.grey),
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Pet Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet?.name ?? 'Unknown Pet',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet?.breed ?? ''} • ${pet?.age ?? 0} years',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.female,
                          size: 16,
                          color: pet?.gender == 'Female'
                              ? Colors.pink
                              : Colors.blue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet?.gender ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (pet?.vaccinated == true) ...[
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.medical_services,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Vaccinated',
                            style: TextStyle(fontSize: 12, color: Colors.green),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Score Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getScoreColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getScoreColor().withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '$score%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(),
                      ),
                    ),
                    Text(
                      _getScoreText(),
                      style: TextStyle(fontSize: 10, color: _getScoreColor()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
