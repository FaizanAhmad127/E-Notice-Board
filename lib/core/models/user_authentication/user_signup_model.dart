class UserSignupModel {

  UserSignupModel(this._email, this._universityId, this._fullName);

  String? _email;
  String? _universityId;
  String? _fullName;


  String? get universityId => _universityId;

  String? get email => _email;

  String? get fullName => _fullName;

  UserSignupModel.fromJson(dynamic json)
{
  _email=json['email'];
  _universityId=json['universityId'];
  _fullName=json['fullName'];
}

Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['email'] = _email;
  map['universityId'] = universityId;
  map['fullName']=_fullName;

  return map;
}
}