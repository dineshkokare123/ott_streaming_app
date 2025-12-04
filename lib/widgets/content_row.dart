import 'package:flutter/material.dart';
import '../models/content.dart';
import '../constants/app_colors.dart';
import 'content_card.dart';

class ContentRow extends StatelessWidget {
  final String title;
  final List<Content> content;
  final Function(Content)? onContentTap;

  const ContentRow({
    super.key,
    required this.title,
    required this.content,
    this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: content.length,
            itemBuilder: (context, index) {
              return ContentCard(
                content: content[index],
                onTap: onContentTap != null
                    ? () => onContentTap!(content[index])
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
