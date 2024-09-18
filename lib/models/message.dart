class Message {
  String sender;
  String message;
  DateTime dateTime;

  Message({
    required this.sender,
    required this.message,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] ?? 'Unknown',
      message: json['message'] ?? '',
      dateTime: DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'date': dateTime.millisecondsSinceEpoch,
    };
  }
}
