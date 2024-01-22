class Message {
  late String _sender;
  late String _message;
  late DateTime _dateTime;

  Message({required String sender, required String message, required DateTime dateTime}) {
    this._dateTime = dateTime;
    this._message = message;
    this._sender = sender;
  }

  String get sender {
    return _sender;
  }

  String get message {
    return _message;
  }

  DateTime get time {
    return _dateTime;
  }
}
