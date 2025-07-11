class User {
  final int userId;
  final String name;
  final String lastName;
  final String nickname;
  final String mail;
  final String password;
  final String photoUrl;

  User({
    required this.userId,
    required this.name,
    required this.lastName,
    required this.nickname,
    required this.mail,
    required this.password,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: _parseUserId(json['userId']),
      name: json['name']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      nickname: json['nickname']?.toString() ?? '',
      mail: json['mail']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
    );
  }

  static int _parseUserId(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return 0;
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'lastName': lastName,
      'nickname': nickname,
      'mail': mail,
      'password': password,
      'photoUrl': photoUrl,
    };
  }

  User.empty()
    : userId = 0,
      name = '',
      lastName = '',
      nickname = '',
      mail = '',
      password = '',
      photoUrl = '';

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, lastName: $lastName, nickName: $nickname, mail: $mail, password: $password, photoUrl: $photoUrl)';
  }
}
