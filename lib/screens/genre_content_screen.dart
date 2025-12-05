import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/content.dart';
import '../constants/app_colors.dart';
import '../constants/api_constants.dart';
import '../widgets/content_card.dart';
import 'content_detail_screen.dart';

class GenreContentScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreContentScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreContentScreen> createState() => _GenreContentScreenState();
}

class _GenreContentScreenState extends State<GenreContentScreen> {
  List<Content> _content = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/discover/movie?api_key=${ApiConstants.apiKey}&with_genres=${widget.genreId}&sort_by=popularity.desc',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        setState(() {
          _content = results.map((json) {
            json['media_type'] = 'movie';
            return Content.fromJson(json);
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading genre content: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.genreName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : _content.isEmpty
          ? const Center(
              child: Text(
                'No content found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: _content.length,
              itemBuilder: (context, index) {
                final item = _content[index];
                return ContentCard(
                  content: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ContentDetailScreen(content: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
