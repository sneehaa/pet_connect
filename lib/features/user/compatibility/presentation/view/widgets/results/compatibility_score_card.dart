import 'package:flutter/material.dart';

class CompatibilityScoreCard extends StatelessWidget {
  final int score;
  final String petName;

  const CompatibilityScoreCard({
    super.key,
    required this.score,
    required this.petName,
  });

  Color _getScoreColor() {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreText() {
    if (score >= 80) return 'Excellent Match!';
    if (score >= 60) return 'Good Match';
    if (score >= 40) return 'Fair Match';
    return 'Poor Match';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getScoreColor().withOpacity(0.1),
            _getScoreColor().withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getScoreColor().withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'Compatibility Score',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(_getScoreColor()),
                ),
              ),
              Column(
                children: [
                  Text(
                    '$score%',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(),
                    ),
                  ),
                  Text(
                    _getScoreText(),
                    style: TextStyle(fontSize: 14, color: _getScoreColor()),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your compatibility with $petName',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
