import 'package:flutter/material.dart';

class BreakdownChart extends StatelessWidget {
  final Map<String, dynamic> breakdown;

  const BreakdownChart({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, dynamic>> entries = breakdown.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compatibility Breakdown',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...entries.map((entry) {
          final category = _formatCategory(entry.key);
          final data = entry.value as Map<String, dynamic>;
          final score = data['score'] as int? ?? 0;
          final detail = data['detail'] as String? ?? '';

          return _buildBar(category, score, detail, data['weight']);
        }),
      ],
    );
  }

  Widget _buildBar(String category, int score, String detail, String weight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getScoreColor(score),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Weight: $weight',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: score / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      _getScoreColor(score).withOpacity(0.8),
                      _getScoreColor(score).withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              detail,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatCategory(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }
}
