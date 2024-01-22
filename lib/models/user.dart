class User {
  late String _name;
  late String _surname;
  late String _imageLink;
  User({required String name, required String surname, required String imageLink}) {
    this._name = name;
    this._surname = surname;
    this._imageLink = imageLink;
  }

  String get name {
    return _name;
  }

  String get imageLink {
    return _imageLink;
  }

  String get surname {
    return _surname;
  }
}
