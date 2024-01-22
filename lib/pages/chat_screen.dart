import 'package:flutter/material.dart';
import 'package:whatsapp_clone/dummies/dummy_messages.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/pages/profile_screen.dart';

class ChatScreen extends StatefulWidget {
  late User receiver;
  ChatScreen({super.key, required this.receiver});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String localUser = "me";
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _messageController = ScrollController();
  List<Message> dummyMessage = DummyMessage.getDummies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                // return ProfileScreen(user: widget.receiver);
                return WhatsappProfilePage();
              },
            ));
          },
          child: Text(widget.receiver.name),
        ),
        leadingWidth: MediaQuery.of(context).size.width * .2,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(backgroundImage: NetworkImage(widget.receiver.imageLink)),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _messageController,
                itemCount: dummyMessage.length,
                itemBuilder: (context, index) {
                  if (dummyMessage[index].sender == localUser) {
                    return sendedMessageItem(dummyMessage[index].message);
                  } else {
                    return receivedMessageItem(dummyMessage[index].message);
                  }
                },
              ),
            ),
            MessageBox(textEditingController: _textEditingController),
          ],
        ),
      ),
    );
  }

  Widget receivedMessageItem(String message) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: 10, right: MediaQuery.of(context).size.width * .25),
      child: Container(
        color: darkGreen,
        height: 30,
        child: Text(message),
      ),
    );
  }

  Widget sendedMessageItem(String message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, left: MediaQuery.of(context).size.width * .25),
      child: Container(
        color: darkGreen,
        height: 30,
        child: Text(message),
      ),
    );
  }

  void _sendMessage(String message) {
    Message new_message =
        Message(sender: "me", message: message, dateTime: DateTime.now());
    _messageController.jumpTo(_messageController.position.maxScrollExtent);
    setState(() {
      dummyMessage.add(new_message);
    });
  }
}

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required TextEditingController textEditingController,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _isFocused = true;
                });
              },
              keyboardType: TextInputType.text,
              textAlignVertical: TextAlignVertical.center,
              cursorColor: darkGreen,
              controller: widget._textEditingController,
              style: const TextStyle(height: 1.5), // Adjust the height value as needed
              decoration: InputDecoration(
                filled: true,
                fillColor: lightBlue,
                hintText: "Message",
                contentPadding: EdgeInsets.zero,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_rounded),
                  onPressed: () {},
                ),
                prefixIconColor: Colors.white,
                suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.attach_file_rounded)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt))
                ]),
                suffixIconColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 5),
          child: Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: darkGreen,
                shape: CircleBorder(),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(_isFocused ? Icons.mic : Icons.send),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _isFocused = false;
  }
}
