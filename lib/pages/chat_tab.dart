import 'package:flutter/material.dart';
import 'package:whatsapp_clone/database/conversation_transactions.dart';
import 'package:whatsapp_clone/models/conversation.dart';
import 'package:whatsapp_clone/pages/chat_screen.dart';
import 'package:whatsapp_clone/pages/create_chat_screen.dart';
import 'package:whatsapp_clone/pages/settings_page.dart';
import 'package:whatsapp_clone/pages/user_profile_page.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});
  static const Icon icon = Icon(Icons.chat);
  static const String label = "Chats";
  static const String routeName = "/chats";

  List<Widget> get actions => [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        PopupMenuButton<String>(
          onSelected: (value) {
            // Seçeneklerden birine tıklandığında yapılacak işlemi buraya yazın
            print('Selected option: $value');
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'profile',
              child: Text('Option 1'),
            ),
            PopupMenuItem<String>(
              value: UserProfilePage.label,
              child: TextButton(
                child: const Text(UserProfilePage.label),
                onPressed: () {
                  Navigator.of(context).pushNamed(UserProfilePage.routeName);
                },
              ),
            ),
            PopupMenuItem<String>(
              value: SettingsPage.label,
              child: TextButton(
                child: const Text(SettingsPage.label),
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsPage.routeName);
                },
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert_outlined),
        ),
      ];

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List<Conversation> conversations = [];

  @override
  void initState() {
    super.initState();
    ConversationTransactions.getConversations().then(
      (value) {
        setState(() {
          if (value != null) {
            conversations = value;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, CreateChatScreen.routeName);
        },
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Icon(Icons.message_rounded),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          return _conversationItem(conversations[index]);
        },
      ),
    );
  }

  Widget _conversationItem(Conversation conversation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            conversation.profilePictureUrl ??
                "https://photosnow.org/wp-content/uploads/2024/04/no-dp_15.jpg",
          ),
        ),
        title: Text(conversation.title),
        subtitle: Text(
          conversation.lastMessage?.message ?? "",
        ),
        trailing: Text(conversation.lastMessage?.date.toIso8601String() ?? ""),
        onTap: () {
          Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: conversation,
          );
          setState(() {});
        },
      ),
    );
  }
}
