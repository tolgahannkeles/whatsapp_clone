import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/models/friend.dart';
import 'package:whatsapp_clone/models/friendship_response.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});
  static const Icon icon = Icon(Icons.add);
  static const String label = "Requests";
  static const String routeName = "/requests";

  List<Widget> get actions => [];

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  List<FriendshipResponse> friendRequests = [];

  @override
  void initState() {
    super.initState();
    _loadFriendRequests();
  }

  void _loadFriendRequests() {
    UserTransactions.getFriendRequests().then(
      (value) {
        setState(() {
          if (value != null) {
            friendRequests = value;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text("FriendRequests"),
          actions: widget.actions,
        ),
        _buildRequestList(friendRequests, requestItem),
      ],
    );
  }

  Widget _buildRequestList(List<FriendshipResponse> requests,
      Widget Function(FriendshipResponse) itemBuilder) {
    return SliverList.builder(
      itemBuilder: (context, index) => itemBuilder(requests[index]),
      itemCount: requests.length,
    );
  }

  Widget requestItem(FriendshipResponse friend) {
    return ListTile(
      title: Text(friend.username),
      trailing: SizedBox(
        width: 160, // Butonlar için daha küçük bir genişlik ayarladım
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleFriendRequest(friend.userId, true),
                child: const Text("Accept"),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleFriendRequest(friend.userId, false),
                child: const Text("Reject"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFriendRequest(String friendId, bool isAccepted) async {
    bool success;
    if (isAccepted) {
      success = await UserTransactions.acceptFriendRequest(friendId);
    } else {
      success = await UserTransactions.rejectFriendRequest(friendId);
    }

    if (success) {
      String message =
          isAccepted ? "Friend request accepted" : "Friend request rejected";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      _loadFriendRequests(); // Listeyi güncelle
    }
  }

  Future<void> _handleCancelRequest(String friendId) async {
    bool success = await UserTransactions.cancelFriendRequest(friendId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Friend request cancelled")),
      );
      _loadFriendRequests(); // Listeyi güncelle
    }
  }
}
