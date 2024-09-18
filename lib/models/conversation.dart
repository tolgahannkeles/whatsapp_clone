import 'package:whatsapp_clone/models/message.dart';

class Conversation {
  String id;
  String title;
  String? profilePictureUrl;
  Message? lastMessage;
  Conversation(
      {required this.id,
      required this.title,
      required this.profilePictureUrl,
      this.lastMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      profilePictureUrl: json['profilePictureUrl'],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
