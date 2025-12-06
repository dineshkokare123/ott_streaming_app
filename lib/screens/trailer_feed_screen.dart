import 'package:flutter/material.dart';

class TrailerFeedScreen extends StatefulWidget {
  const TrailerFeedScreen({super.key});

  @override
  State<TrailerFeedScreen> createState() => _TrailerFeedScreenState();
}

class _TrailerFeedScreenState extends State<TrailerFeedScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Mock Data
  final List<Map<String, String>> _trailers = [
    {
      'title': 'Stranger Things 4',
      'image':
          'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      'desc': 'Darkness returns to Hawkins.',
    },
    {
      'title': 'The Mandalorian',
      'image':
          'https://image.tmdb.org/t/p/w500/sWgBv7LV2PRoQgkxwlibdGXKz1S.jpg',
      'desc': 'This is the Way.',
    },
    {
      'title': 'Inception',
      'image':
          'https://image.tmdb.org/t/p/w500/8c4a8kE7PizaGQQnditMmI1xbRp.jpg',
      'desc': 'Your mind is the scene of the crime.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: _trailers.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildTrailerPage(
                _trailers[index],
                index == _currentIndex,
              );
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailerPage(Map<String, String> data, bool isVisible) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image (Simulates Video)
        Image.network(
          data['image']!,
          fit: BoxFit.cover,
          color: Colors.black.withValues(alpha: 0.4),
          colorBlendMode: BlendMode.darken,
        ),

        // "Video Player" Elements
        Center(
          child: isVisible
              ? const Icon(
                  Icons.play_arrow,
                  size: 80,
                  color: Colors.white24,
                ) // Should disappear if playing
              : const SizedBox(),
        ),

        // Info Layer
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black87],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['desc']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('My List'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withValues(alpha: 0.3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),

        // Side Actions
        Positioned(
          right: 16,
          bottom: 150,
          child: Column(
            children: [
              _buildSideAction(Icons.favorite, '245k'),
              const SizedBox(height: 20),
              _buildSideAction(Icons.comment, '1.2k'),
              const SizedBox(height: 20),
              _buildSideAction(Icons.share, 'Share'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
