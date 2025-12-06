import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/social_service.dart';
import '../constants/app_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatefulWidget {
  final String contentId;

  const CommentSection({super.key, required this.contentId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<SocialService>(context);
    final comments = service.getComments(widget.contentId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Discussion',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
                radius: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _postComment(service),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () => _postComment(service),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24),
        // List
        if (comments.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Be the first to comment!',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Assuming inside a scrollable parent
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(comment.user.avatarUrl),
                  radius: 16,
                ),
                title: Row(
                  children: [
                    Text(
                      comment.user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeago.format(comment.timestamp),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.thumb_up_alt_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${comment.likes}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Reply',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  void _postComment(SocialService service) {
    if (_controller.text.isNotEmpty) {
      service.addComment(widget.contentId, _controller.text);
      _controller.clear();
    }
  }
}
