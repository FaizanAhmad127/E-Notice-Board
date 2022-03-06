class UserSignupModel {

  UserSignupModel(this._email, this._universityId, this._fullName,this._uid);

  String? _email;
  String? _universityId;
  String? _fullName;
  String? _uid;
  String _profilePicture="";
  String _available="yes";


  String get available => _available;

  String? get profilePicture => _profilePicture;

  String? get uid => _uid;

  String? get universityId => _universityId;

  String? get email => _email;

  String? get fullName => _fullName;

  UserSignupModel.fromJson(dynamic json)
{
  _email=json['email'];
  _universityId=json['universityId'];
  _fullName=json['fullName'];
  _profilePicture=json['profilePicture'];
  _available=json['available'];
}

Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['email'] = _email;
  map['universityId'] = universityId;
  map['fullName']=_fullName;
  map['profilePicture']=_profilePicture;
  map['available']=_available;

  return map;
}
}