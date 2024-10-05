class Message {
  String sender;
  String message;
  DateTime date;

  Message({
    required this.sender,
    required this.message,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] ?? 'Unknown',
      message: json['message'] ?? '',
      date: DateTime.parse(json["date"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'message': message,
      'date': date.millisecondsSinceEpoch,
    };
  }
}
