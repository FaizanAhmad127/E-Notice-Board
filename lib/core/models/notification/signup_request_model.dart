class SignupRequestModel{
  String? _fullName;
  String? _isApproved="no";
  String? _occupation;
  int? _timeStamp;
  String? _uid;
  String? _universityId;
  String? _email;

  SignupRequestModel(this._fullName,this._occupation,this._timeStamp,this._uid,this._universityId,this._email);

  String? get fullName => _fullName;

  String? get isApproved => _isApproved;

  String? get occupation => _occupation;

  int? get timeStamp => _timeStamp;

  String? get uid => _uid;

  String? get universityId => _universityId;

  String? get email=>_email;

  SignupRequestModel.fromJson(dynamic json)
  {
    _fullName=json['fullName'];
    _isApproved=json['isApproved'];
    _occupation=json['occupation'];
    _timeStamp=json['timeStamp'];
    _uid=json['uid'];
    _universityId=json['universityId'];
    _email=json['email'];
  }

  Map< String , dynamic > toJson()
  {
    Map<String,dynamic> map={};
    map['fullName'] = _fullName;
    map['isApproved'] = _isApproved;
    map['occupation'] = _occupation ;
    map['timeStamp'] =_timeStamp ;
    map['uid'] =_uid;
    map['universityId'] =_universityId;
    map['email']=_email;

    return map;
  }
}