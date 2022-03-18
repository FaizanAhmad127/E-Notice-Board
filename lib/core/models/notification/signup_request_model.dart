class SignupRequestModel{
  String? _fullName;
  String? _isApproved="no";
  String? _occupation;
  int? _timeStamp;
  String? _uid;
  String? _universityId;

  SignupRequestModel(this._fullName,this._occupation,this._timeStamp,this._uid,this._universityId);

  String? get fullName => _fullName;

  String? get isApproved => _isApproved;

  String? get occupation => _occupation;

  int? get timeStamp => _timeStamp;

  String? get uid => _uid;

  String? get universityId => _universityId;

  SignupRequestModel.fromJson(dynamic json)
  {
    _fullName=json['fullName'];
    _isApproved=json['isApproved'];
    _occupation=json['occupation'];
    _timeStamp=json['timeStamp'];
    _uid=json['uid'];
    _universityId=json['universityId'];
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

    return map;
  }
}