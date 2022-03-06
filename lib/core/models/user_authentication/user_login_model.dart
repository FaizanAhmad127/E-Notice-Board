class UserLoginModel{

  UserLoginModel(this._email,this._password);
  final String _email;
  final String _password;

  String get email => _email;
  String get password => _password;
  //
  // UserLoginModel.fromJson(dynamic json)
  // {
  //   _email=json['email'];
  //   _password=json['password'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final map = <String, dynamic>{};
  //   map['email'] = _email;
  //   map['password'] = _password;
  //   return map;
  // }

}