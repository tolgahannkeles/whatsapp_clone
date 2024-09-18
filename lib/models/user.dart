import 'package:uuid/uuid.dart';

class User {
  String id;
  String username;
  List<String> email;
  String? profilePicture;
  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<dynamic> emailJson = json["email"];
    List<String> emails = emailJson.cast<String>();

    return User(
      id: json["id"],
      username: json["username"],
      email: emails,
    );
  }
}
