import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cast.dart';
import '../models/content.dart';
import '../constants/app_colors.dart';
import '../constants/api_constants.dart';
import '../widgets/content_card.dart';
import 'content_detail_screen.dart';

class ActorDetailScreen extends StatefulWidget {
  final int actorId;
  final String actorName;

  const ActorDetailScreen({
    super.key,
    required this.actorId,
    required this.actorName,
  });

  @override
  State<ActorDetailScreen> createState() => _ActorDetailScreenState();
}

class _ActorDetailScreenState extends State<ActorDetailScreen> {
  ActorDetails? _actorDetails;
  List<Content> _credits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActorData();
  }

  Future<void> _loadActorData() async {
    setState(() => _isLoading = true);

    try {
      // Load actor details
      final detailsResponse = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/person/${widget.actorId}?api_key=${ApiConstants.apiKey}',
        ),
      );

      // Load actor credits
      final creditsResponse = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}/person/${widget.actorId}/movie_credits?api_key=${ApiConstants.apiKey}',
        ),
      );

      if (detailsResponse.statusCode == 200 &&
          creditsResponse.statusCode == 200) {
        final detailsData = json.decode(detailsResponse.body);
        final creditsData = json.decode(creditsResponse.body);

        setState(() {
          _actorDetails = ActorDetails.fromJson(detailsData);

          final cast = creditsData['cast'] as List;
          _credits = cast.take(20).map((json) {
            json['media_type'] = 'movie';
            return Content.fromJson(json);
          }).toList();

          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading actor data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_actorDetails == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
        body: const Center(
          child: Text(
            'Failed to load actor details',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: _actorDetails!.profilePath != null
                  ? CachedNetworkImage(
                      imageUrl: ApiConstants.getPosterUrl(
                        _actorDetails!.profilePath!,
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: AppColors.backgroundLight),
                    )
                  : Container(
                      color: AppColors.backgroundLight,
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: AppColors.textSecondary,
                      ),
                    ),
            ),
          ),

          // Actor Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    _actorDetails!.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Cards
                  Row(
                    children: [
                      if (_actorDetails!.age != null)
                        Expanded(
                          child: _buildInfoCard(
                            'Age',
                            _actorDetails!.age!,
                            Icons.cake,
                          ),
                        ),
                      if (_actorDetails!.age != null) const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Popularity',
                          _actorDetails!.popularity.toStringAsFixed(1),
                          Icons.trending_up,
                        ),
                      ),
                    ],
                  ),

                  if (_actorDetails!.placeOfBirth != null) ...[
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      Icons.location_on,
                      'Born in',
                      _actorDetails!.placeOfBirth!,
                    ),
                  ],

                  if (_actorDetails!.birthday != null) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Birthday',
                      _formatDate(_actorDetails!.birthday!),
                    ),
                  ],

                  // Biography
                  if (_actorDetails!.biography != null &&
                      _actorDetails!.biography!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Biography',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _actorDetails!.biography!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],

                  // Known For
                  if (_credits.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Known For',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _credits.length,
                        itemBuilder: (context, index) {
                          final content = _credits[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index == _credits.length - 1 ? 0 : 12,
                            ),
                            child: ContentCard(
                              content: content,
                              width: 130,
                              height: 200,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ContentDetailScreen(content: content),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
