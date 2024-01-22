import 'package:flutter/material.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/pages/chat_screen.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _conversationItem();
      },
    );
  }

  User user =
      User(name: "Ar*p", surname: "Fatih", imageLink: "https://picsum.photos/200");

  Widget _conversationItem() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.imageLink),
          ),
          title: Text(user.name),
          subtitle: const Text("~ Şehmuz: Sa reis"),
          trailing: const Text("17:06"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ChatScreen(
                  receiver: user,
                );
              },
            ));
          },
        ));
  }
}
