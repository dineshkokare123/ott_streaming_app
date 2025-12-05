class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int,
      name: json['name'] as String,
      character: json['character'] as String? ?? 'Unknown',
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}

class ActorDetails {
  final int id;
  final String name;
  final String? biography;
  final String? profilePath;
  final String? birthday;
  final String? placeOfBirth;
  final double popularity;

  ActorDetails({
    required this.id,
    required this.name,
    this.biography,
    this.profilePath,
    this.birthday,
    this.placeOfBirth,
    required this.popularity,
  });

  factory ActorDetails.fromJson(Map<String, dynamic> json) {
    return ActorDetails(
      id: json['id'] as int,
      name: json['name'] as String,
      biography: json['biography'] as String?,
      profilePath: json['profile_path'] as String?,
      birthday: json['birthday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String? get age {
    if (birthday == null) return null;
    try {
      final birthDate = DateTime.parse(birthday!);
      final now = DateTime.now();
      var age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age.toString();
    } catch (e) {
      return null;
    }
  }
}
