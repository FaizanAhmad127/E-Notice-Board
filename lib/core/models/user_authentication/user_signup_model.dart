import 'dart:core';


class UserSignupModel {

  UserSignupModel(this._email, this._universityId, this._fullName,this._uid,this._occupation);

  String? _email;
  String? _universityId;
  String? _fullName;
  String? _uid;
  String _profilePicture="";
  String _available="yes";
  List<String> _ideaList=[];
  List<String> _chatList=[];
  String? _occupation;
  String _onlineStatus="offline";


  List<String> get ideaList=>_ideaList;

  List<String> get chatList=>_chatList;

  String get available => _available;

  String? get profilePicture => _profilePicture;

  String? get uid => _uid;

  String? get universityId => _universityId;

  String? get email => _email;

  String? get fullName => _fullName;

  String? get occupation=>_occupation;

  String get onlineStatus=>_onlineStatus;

  UserSignupModel.fromJson(dynamic json)
{
  _email=json['email'];
  _universityId=json['universityId'];
  _fullName=json['fullName'];
  _profilePicture=json['profilePicture'];
  _uid=json['uid'];
  _available=json['available'];
  _ideaList=List<String>.from(json['ideaList']);
  _chatList=List<String>.from(json['chatList']);
  _occupation=json['occupation'];
  _onlineStatus=json['onlineStatus'];
}

Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['email'] = _email;
  map['universityId'] = _universityId;
  map['fullName']=_fullName;
  map['profilePicture']=_profilePicture;
  map['uid']=_uid;
  map['available']=_available;
  map['ideaList']=_ideaList;
  map['chatList']=_chatList;
  map['occupation']=_occupation;
  map['onlineStatus']=_onlineStatus;

  return map;
}
}