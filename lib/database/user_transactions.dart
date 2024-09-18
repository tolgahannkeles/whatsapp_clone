import 'dart:convert';
import 'dart:developer';

import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/database/shared_preferences_util.dart';
import 'package:whatsapp_clone/models/friend.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_clone/models/friendship_response.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/models/enum_friendship_status.dart';

class UserTransactions {
  static String baseAccountUrl = "http://10.0.2.2:8080/api/account";
  static String baseUserUrl = "http://10.0.2.2:8080/api/user";

  static Future<List<Friend>> getFriends() async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};

    var response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Failed to get friends: ${jsonDecode(response.body)}");
    }
    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => Friend.fromJson(e)).toList();
  }

  static Future<User?> getLocalUser() async {
    Uri? uri = Uri.tryParse(baseUserUrl);
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};

    var response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Failed to get friends: ${jsonDecode(response.body)}");
    }
    var json = jsonDecode(response.body);
    return User.fromJson(json);
  }

  static Future<List<Friend>> findUserByUsernameStartingWith(
      String startingWith) async {
    Uri? uri = Uri.tryParse("$baseUserUrl/search/$startingWith");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};

    var response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Failed to get friends: ${jsonDecode(response.body)}");
    }
    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => Friend.fromJson(e)).toList();
  }

  static Future<bool> sendFriendRequest(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/requests");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"userId": friendId};

    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to send friend request: ${jsonDecode(response.body)}");
    }
    return true;
  }

  static Future<List<FriendshipResponse>> getFriendRequests() async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/requests");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};

    var response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception("Failed to get friends: ${jsonDecode(response.body)}");
    }
    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => FriendshipResponse.fromJson(e)).toList();
  }

  static Future<bool> acceptFriendRequest(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/requests/$friendId");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"status": FriendshipStatus.ACCEPTED.toString().split('.').last};

    var response =
        await http.patch(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to accept friend request: ${jsonDecode(response.body)}");
    }
    return true;
  }

  static Future<bool> rejectFriendRequest(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/reject");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"id": friendId};

    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to decline friend request: ${jsonDecode(response.body)}");
    }
    return true;
  }

  static Future<bool> blockFriend(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/block");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"id": friendId};

    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception("Failed to block friend: ${jsonDecode(response.body)}");
    }
    return true;
  }

  static Future<bool> unblockFriend(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/unblock");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"id": friendId};

    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception("Failed to unblock friend: ${jsonDecode(response.body)}");
    }
    return true;
  }

  static Future<bool> cancelFriendRequest(String friendId) async {
    Uri? uri = Uri.tryParse("$baseAccountUrl/friends/cancel");
    if (uri == null) throw Exception("Invalid URI");
    String? token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) throw Exception("Token is null");
    var headers = {'Content-Type': 'application/json', 'Authorization': token};
    var body = {"id": friendId};

    var response =
        await http.post(uri, headers: headers, body: jsonEncode(body));
    if (response.statusCode != 200) {
      throw Exception(
          "Failed to cancel friend request: ${jsonDecode(response.body)}");
    }
    return true;
  }
}
