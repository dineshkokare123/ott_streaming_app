import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/content_extras_service.dart';
import '../constants/app_colors.dart';

class BonusContentScreen extends StatelessWidget {
  const BonusContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In real app, pass contentId. Using mock getters for now.
    final service = Provider.of<ContentExtrasService>(context);
    final bonuses = service.getBonusContent('mock_id');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Extras & Behind the Scenes'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bonuses.length,
        itemBuilder: (context, index) {
          final item = bonuses[index];
          return Card(
            color: AppColors.backgroundLight,
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      color: Colors.grey.shade900, // Placeholder for image
                      width: double.infinity,
                      child: const Icon(
                        Icons.movie_creation,
                        size: 64,
                        color: Colors.white24,
                      ),
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      size: 64,
                      color: Colors.white,
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getTypeLabel(item.type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'making_of':
        return 'Making Of';
      case 'interview':
        return 'Interview';
      case 'bloopers':
        return 'Bloopers';
      default:
        return 'Bonus';
    }
  }
}
