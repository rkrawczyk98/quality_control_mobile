class User {
  final int id;
  final String username;
  final DateTime creationDate;
  final DateTime lastModified;
  final bool isDeleted;

  User({
    required this.id,
    required this.username,
    required this.creationDate,
    required this.lastModified,
    required this.isDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      creationDate: DateTime.parse(json['creationDate']),
      lastModified: DateTime.parse(json['lastModified']),
      isDeleted: json['isDeleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'creationDate': creationDate.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }
}

class CreateUserDto {
  final String username;
  final String password;

  CreateUserDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class UpdateUserDto {
  final String currentPassword;
  final String newPassword;

  UpdateUserDto({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
