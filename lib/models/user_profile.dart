class UserProfile {
  final String id;
  final String userId; // Parent user ID
  final String name;
  final String avatarUrl;
  final bool isKidsProfile;
  final List<int> watchlist;
  final List<int> favorites;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.avatarUrl,
    this.isKidsProfile = false,
    this.watchlist = const [],
    this.favorites = const [],
    required this.createdAt,
  });

  UserProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? avatarUrl,
    bool? isKidsProfile,
    List<int>? watchlist,
    List<int>? favorites,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isKidsProfile: isKidsProfile ?? this.isKidsProfile,
      watchlist: watchlist ?? this.watchlist,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'avatarUrl': avatarUrl,
      'isKidsProfile': isKidsProfile,
      'watchlist': watchlist,
      'favorites': favorites,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      isKidsProfile: json['isKidsProfile'] as bool? ?? false,
      watchlist:
          (json['watchlist'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      favorites:
          (json['favorites'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

// Predefined avatar options
class ProfileAvatar {
  final String id;
  final String url;
  final String name;

  const ProfileAvatar({
    required this.id,
    required this.url,
    required this.name,
  });

  static const List<ProfileAvatar> avatars = [
    ProfileAvatar(id: 'avatar_1', url: '🎭', name: 'Theater'),
    ProfileAvatar(id: 'avatar_2', url: '🎬', name: 'Clapper'),
    ProfileAvatar(id: 'avatar_3', url: '🎪', name: 'Circus'),
    ProfileAvatar(id: 'avatar_4', url: '🎨', name: 'Art'),
    ProfileAvatar(id: 'avatar_5', url: '🎮', name: 'Gaming'),
    ProfileAvatar(id: 'avatar_6', url: '🎸', name: 'Music'),
    ProfileAvatar(id: 'avatar_7', url: '🎯', name: 'Target'),
    ProfileAvatar(id: 'avatar_8', url: '🎲', name: 'Dice'),
    ProfileAvatar(id: 'avatar_9', url: '🚀', name: 'Rocket'),
    ProfileAvatar(id: 'avatar_10', url: '⚽', name: 'Soccer'),
    ProfileAvatar(id: 'avatar_11', url: '🏀', name: 'Basketball'),
    ProfileAvatar(id: 'avatar_12', url: '🎾', name: 'Tennis'),
    ProfileAvatar(id: 'avatar_13', url: '🦁', name: 'Lion'),
    ProfileAvatar(id: 'avatar_14', url: '🐼', name: 'Panda'),
    ProfileAvatar(id: 'avatar_15', url: '🦊', name: 'Fox'),
    ProfileAvatar(id: 'avatar_16', url: '🐯', name: 'Tiger'),
    ProfileAvatar(id: 'avatar_17', url: '🦄', name: 'Unicorn'),
    ProfileAvatar(id: 'avatar_18', url: '🐉', name: 'Dragon'),
    ProfileAvatar(id: 'avatar_19', url: '🌟', name: 'Star'),
    ProfileAvatar(id: 'avatar_20', url: '💎', name: 'Diamond'),
  ];

  static ProfileAvatar getById(String id) {
    return avatars.firstWhere(
      (avatar) => avatar.id == id,
      orElse: () => avatars[0],
    );
  }

  static ProfileAvatar random() {
    return avatars[(DateTime.now().millisecondsSinceEpoch % avatars.length)];
  }
}
