import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:whatsapp_clone/database/conversation_transactions.dart';
import 'package:whatsapp_clone/database/user_transactions.dart';
import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/conversation.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/pages/profile_screen.dart';
import 'package:whatsapp_clone/web-socket/stomp_service.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chat_screen";
  final Conversation conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _messageController = ScrollController();
  final StompService _stompService = StompService();
  List<Message> messages = [];
  String username = "-";

  @override
  void initState() {
    super.initState();

    UserTransactions.getLocalUser().then((value) {
      if (value != null) {
        username = value.username;

        ConversationTransactions.getMessages(widget.conversation).then((value) {
          setState(() {
            messages = value;
          });
        });

        _connectToWebSocket();
      }
    });
  }

  void _connectToWebSocket() {
    _stompService.connect(
      onConnectCallback: (StompFrame frame) {
        print('Connected to WebSocket');

        _stompService.subscribeToConversation(
          widget.conversation.id.toString(),
          _onMessageReceived,
        );
      },
    );
  }

  void _onMessageReceived(StompFrame frame) {
    Map<String, dynamic> messageData = jsonDecode(frame.body!);

    setState(() {
      messages.add(Message(
        sender: messageData['sender']['username'],
        message: messageData['message'],
      ));
    });

    _scrollToBottom();
  }

  void _sendMessage(String message) {
    if (_stompService.stompClient.connected) {
      // Only send the message if the connection is established
      print(message);
      Message newMessage = Message(sender: username, message: message);
      _stompService.sendMessage(
        '/api/messages/chat.sendMessage/${widget.conversation.id}',
        newMessage,
      );
    } else {
      print('Unable to send message: WebSocket connection is not established.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageController.jumpTo(_messageController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    _stompService.disconnect();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const WhatsappProfilePage();
              },
            ));
          },
          child: Text(widget.conversation.title),
        ),
        leadingWidth: MediaQuery.of(context).size.width * .2,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              const Icon(Icons.arrow_back),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.conversation.profilePictureUrl ??
                      "https://www.shutterstock.com/image-vector/vector-flat-illustration-grayscale-avatar-600nw-2264922221.jpg",
                ),
              ),
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
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return messages[index].sender == username
                      ? _sendedMessageItem(messages[index].message)
                      : _receivedMessageItem(messages[index].message);
                },
              ),
            ),
            MessageBox(
              textEditingController: _textEditingController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _receivedMessageItem(String message) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 10, right: MediaQuery.of(context).size.width * .25),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: darkGreen,
        child: Text(message),
      ),
    );
  }

  Widget _sendedMessageItem(String message) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 10, left: MediaQuery.of(context).size.width * .25),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: darkGreen,
        child: Text(message),
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
  const MessageBox({
    super.key,
    required this.textEditingController,
    required this.onSend,
  });

  final TextEditingController textEditingController;
  final Function(String) onSend;

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
              controller: widget.textEditingController,
              style: const TextStyle(height: 1.5),
              decoration: InputDecoration(
                filled: true,
                fillColor: lightBlue,
                hintText: "Message",
                contentPadding: EdgeInsets.zero,
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_rounded),
                  onPressed: () {},
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file_rounded)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.camera_alt)),
                  ],
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Ink(
            decoration: const ShapeDecoration(
              color: darkGreen,
              shape: CircleBorder(),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(_isFocused ? Icons.send : Icons.mic),
              color: Colors.white,
              onPressed: () {
                widget.onSend(widget.textEditingController.text);
              },
            ),
          ),
        ),
      ],
    );
  }
}
