import 'dart:convert';

import 'package:whatsapp_clone/database/shared_preferences_util.dart';
import 'package:whatsapp_clone/models/conversation.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/models/message.dart';

class ConversationTransactions {
  static String baseUrl = "http://10.0.2.2:8080/api/conversation";
  static String baseMessageUrl = "http://10.0.2.2:8080/api/messages";

  static Future<List<Conversation>?> getConversations() async {
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }
    Uri? uri = Uri.tryParse(baseUrl);
    if (uri == null) {
      throw Exception("Invalid URI");
    }
    var response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to get conversations -> ${jsonDecode(response.body)}");
    }

    List<dynamic> responseList = jsonDecode(response.body);

    return responseList
        .map(
          (e) => Conversation.fromJson(e),
        )
        .toList();
  }

  static Future<List<Message>> getMessages(Conversation conversation) async {
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }
    Uri? uri = Uri.tryParse(
        "http://10.0.2.2:8080/api/messages/topic/conversation/${conversation.id}");
    if (uri == null) {
      throw Exception("Invalid URI");
    }
    var response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to get conversations");
    }

    List<dynamic> responseList = jsonDecode(response.body);
    List<Message> messages = responseList
        .map(
          (e) => Message.fromJson(e),
        )
        .toList();
    return messages;
  }

  static Future<void> createGroup(
      String title, List<String> participants) async {
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }
    Uri? uri = Uri.tryParse("$baseUrl/groups");
    if (uri == null) {
      throw Exception("Invalid URI");
    }
    var body = {"title": title, "participants": participants};
    var response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });

    if (response.statusCode != 200) {
      throw Exception("Failed to create group -> ${jsonDecode(response.body)}");
    }
  }

  static Future<void> sendMessage(
      Conversation conversation, Message newMessage) async {
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }
    Uri? uri = Uri.tryParse("$baseMessageUrl/${conversation.id}");
    if (uri == null) {
      throw Exception("Invalid URI");
    }

    await http.post(uri, body: jsonEncode(newMessage.toJson()), headers: {
      'Content-Type': 'application/json',
      'Authorization': token,
    });
  }
}
