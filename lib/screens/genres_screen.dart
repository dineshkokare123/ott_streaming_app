import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'genre_content_screen.dart';

class Genre {
  final int id;
  final String name;
  final IconData icon;
  final Color color;

  const Genre({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key});

  static const List<Genre> movieGenres = [
    Genre(
      id: 28,
      name: 'Action',
      icon: Icons.local_fire_department,
      color: Colors.red,
    ),
    Genre(id: 12, name: 'Adventure', icon: Icons.explore, color: Colors.orange),
    Genre(
      id: 16,
      name: 'Animation',
      icon: Icons.animation,
      color: Colors.purple,
    ),
    Genre(
      id: 35,
      name: 'Comedy',
      icon: Icons.sentiment_very_satisfied,
      color: Colors.yellow,
    ),
    Genre(id: 80, name: 'Crime', icon: Icons.gavel, color: Colors.grey),
    Genre(
      id: 99,
      name: 'Documentary',
      icon: Icons.movie_filter,
      color: Colors.brown,
    ),
    Genre(
      id: 18,
      name: 'Drama',
      icon: Icons.theater_comedy,
      color: Colors.blue,
    ),
    Genre(
      id: 10751,
      name: 'Family',
      icon: Icons.family_restroom,
      color: Colors.green,
    ),
    Genre(
      id: 14,
      name: 'Fantasy',
      icon: Icons.auto_awesome,
      color: Colors.pink,
    ),
    Genre(
      id: 27,
      name: 'Horror',
      icon: Icons.nightlight,
      color: Colors.deepPurple,
    ),
    Genre(id: 10402, name: 'Music', icon: Icons.music_note, color: Colors.cyan),
    Genre(id: 9648, name: 'Mystery', icon: Icons.search, color: Colors.indigo),
    Genre(
      id: 10749,
      name: 'Romance',
      icon: Icons.favorite,
      color: Colors.pinkAccent,
    ),
    Genre(
      id: 878,
      name: 'Sci-Fi',
      icon: Icons.rocket_launch,
      color: Colors.teal,
    ),
    Genre(id: 10770, name: 'TV Movie', icon: Icons.tv, color: Colors.blueGrey),
    Genre(
      id: 53,
      name: 'Thriller',
      icon: Icons.flash_on,
      color: Colors.deepOrange,
    ),
    Genre(
      id: 10752,
      name: 'War',
      icon: Icons.military_tech,
      color: Colors.brown,
    ),
    Genre(id: 37, name: 'Western', icon: Icons.landscape, color: Colors.amber),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Browse by Genre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: movieGenres.length,
        itemBuilder: (context, index) {
          final genre = movieGenres[index];
          return _buildGenreCard(context, genre);
        },
      ),
    );
  }

  Widget _buildGenreCard(BuildContext context, Genre genre) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                GenreContentScreen(genreId: genre.id, genreName: genre.name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              genre.color.withValues(alpha: 0.8),
              genre.color.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: genre.color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Icon
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                genre.icon,
                size: 120,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(genre.icon, color: Colors.white, size: 32),
                  Text(
                    genre.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
