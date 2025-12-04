class AppUser {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final List<int> watchlist;
  final List<int> favorites;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    List<int>? watchlist,
    List<int>? favorites,
    DateTime? createdAt,
  }) : watchlist = watchlist ?? [],
       favorites = favorites ?? [],
       createdAt = createdAt ?? DateTime.now();

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'] ?? 'User',
      photoUrl: json['photoUrl'],
      watchlist: json['watchlist'] != null
          ? List<int>.from(json['watchlist'])
          : [],
      favorites: json['favorites'] != null
          ? List<int>.from(json['favorites'])
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'watchlist': watchlist,
      'favorites': favorites,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    List<int>? watchlist,
    List<int>? favorites,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      watchlist: watchlist ?? this.watchlist,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
