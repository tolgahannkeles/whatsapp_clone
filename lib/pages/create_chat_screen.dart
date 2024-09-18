import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/conversation_transactions.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/models/friend.dart';

class CreateChatScreen extends StatefulWidget {
  const CreateChatScreen({super.key});
  static const routeName = "/create_chat";
  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  List<Friend> friends = [];
  TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    try {
      UserTransactions.getFriends().then((value) {
        friends = value;
        setState(() {});
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Chat"),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) => friendItem(friends[index]),
      ),
    );
  }

  Widget friendItem(Friend friend) {
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(
          "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",
        ),
      ),
      title: Text(friend.username),
      subtitle: Text(friend.friendshipStatus?.name ?? "null"),
      onTap: () {
        _showGroupNameDialog(friend);
      },
    );
  }

  // Grup ismini alacağımız dialog
  void _showGroupNameDialog(Friend friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Group Name'),
          content: TextField(
            controller: groupNameController,
            decoration: const InputDecoration(hintText: "Group Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String groupName = groupNameController.text;
                if (groupName.isNotEmpty) {
                  _createGroup(groupName, friend);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Grubu oluşturma fonksiyonu
  void _createGroup(String groupName, Friend friend) async {
    try {
      await ConversationTransactions.createGroup(groupName, [friend.id]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Group '$groupName' created with ${friend.username}")),
      );
    } catch (e) {
      log('Error creating group: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create group")),
      );
    }
  }
}
