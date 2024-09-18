class MessageRequest {
  String message;
  DateTime dateTime;

  // Constructor updated to assign the current time if not provided
  MessageRequest({required this.message, DateTime? dateTime})
      : dateTime = dateTime ?? DateTime.now();

  // Factory method to create Message instance from JSON
  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
      message: json['message'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  // Method to convert Message instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'dateTime': dateTime.toIso8601String(), // ISO format is MySQL compatible
    };
  }
}
