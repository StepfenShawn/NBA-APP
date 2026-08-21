class Team {
  final int id;
  final String abbreviation;
  final String city;
  final String name;
  final String fullName;

  Team({
    required this.id,
    required this.abbreviation,
    required this.city,
    required this.name,
    required this.fullName,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      abbreviation: json['abbreviation'],
      city: json['city'],
      name: json['name'],
      fullName: json['full_name'],
    );
  }
}
