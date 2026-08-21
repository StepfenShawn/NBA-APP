class Player {
  final int id;
  final String firstName;
  final String lastName;
  final String position;
  final String? height;
  final String? weight;

  Player({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.position,
    this.height,
    this.weight,
  });

  String get fullName => "$firstName $lastName";

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      position: json['position'] ?? 'N/A',
      height: json['height'],
      weight: json['weight'],
    );
  }
}
