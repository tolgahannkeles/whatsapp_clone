import 'package:whatsapp_clone/models/enum_friendship_status.dart';

class FriendshipResponse {
  int id;
  String userId;
  FriendshipStatus status;
  String username;

  FriendshipResponse(
      {required this.id,
      required this.userId,
      required this.status,
      required this.username});

  factory FriendshipResponse.fromJson(Map<String, dynamic> json) {
    return FriendshipResponse(
        id: json['id'],
        userId: json['userId'],
        status: FriendshipStatus.values.firstWhere(
          (element) => element.name.toUpperCase() == json["status"],
        ),
        username: json['username']);
  }
}
