import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/models/enum_friendship_status.dart';

class Friend {
  String id; // UuidValue ile UUID'yi saklıyoruz
  String username;
  String? profilePicture;
  List<String> email;
  FriendshipStatus friendshipStatus;

  Friend({
    required this.id,
    required this.username,
    required this.friendshipStatus,
    required this.email,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json["id"], // UuidValue ile UUID'yi oluşturuyoruz
      username: json["username"],
      friendshipStatus: FriendshipStatus.values.firstWhere(
        (element) => element.name.toUpperCase() == json["friendshipStatus"],
      ),
      email: List<String>.from(json["email"]),
    );
  }
}
