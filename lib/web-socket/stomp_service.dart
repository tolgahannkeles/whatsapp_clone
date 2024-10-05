import 'dart:convert';
import 'dart:developer';

import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:whatsapp_clone/database/shared_preferences_util.dart';
import 'package:whatsapp_clone/models/message.dart';

class StompService {
  late StompClient stompClient;
  String? token;

  Future<void> connect({
    required Function(StompFrame) onConnectCallback,
  }) async {
    token = await SharedPreferencesUtil.getAccessToken();
    if (token == null) {
      throw Exception("Token is not available");
    }
    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://10.0.2.2:8080/ws', // WebSocket endpoint
        onConnect: onConnectCallback,
        onDisconnect: (StompFrame frame) =>
            print('Disconnected from WebSocket'),
        onStompError: (StompFrame frame) => print('STOMP Error: ${frame.body}'),
        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        onWebSocketDone: () => print('WebSocket connection closed.'),
        stompConnectHeaders: {'Authorization': token!},
        webSocketConnectHeaders: {'Authorization': token},
        reconnectDelay: const Duration(seconds: 10),
      ),
    );

    inspect(stompClient);

    stompClient.activate();
  }

  void disconnect() {
    stompClient.deactivate();
  }

  void sendMessage(String destination, Message message) {
    inspect(message);
    inspect(stompClient);
    if (token == null) {
      throw Exception("Token is not available");
    }
    stompClient.send(
        destination: destination,
        body: jsonEncode(message.toJson()),
        headers: {'Authorization': token!});
  }

  void subscribeToConversation(
    String conversationId,
    Function(StompFrame) onMessageReceived,
  ) {
    stompClient.subscribe(
      destination: '/topic/conversation/$conversationId',
      callback: onMessageReceived,
    );
  }
}
