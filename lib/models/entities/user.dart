class User {
  final int userId;
  final String name;
  final String lastName;
  final String nickname;
  final String mail;
  final String password;

  User({
    required this.userId,
    required this.name,
    required this.lastName,
    required this.nickname,
    required this.mail,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      lastName: json['lastName'],
      nickname: json['nickname'],
      mail: json['mail'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'lastName': lastName,
      'nickname': nickname,
      'mail': mail,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, lastName: $lastName, nickName: $nickname, mail: $mail, password: $password)';
  }
}
