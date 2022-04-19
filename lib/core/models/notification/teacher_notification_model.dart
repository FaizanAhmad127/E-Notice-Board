class TeacherNotificationModel{
  String? _notificationType;
  String? _ideaId;
  String? _ideaTitle;
  String? _ideaType;
  int? _timeStamp;
  String _status="pending";



  String? get notificationType => _notificationType;
  String? get ideaId => _ideaId;
  String? get ideaTitle=>_ideaTitle;
  String? get ideaType=>_ideaType;
  int? get timeStamp=>_timeStamp;
  String get status=>_status;


  TeacherNotificationModel(this._notificationType,this._ideaId,this._ideaTitle,this._ideaType,this._timeStamp);


  TeacherNotificationModel.fromJson(dynamic json)
  {
    _notificationType=json['notificationType'];
    _ideaId=json['ideaId'];
    _ideaTitle=json['ideaTitle'];
    _ideaType=json['ideaType'];
    _timeStamp=json['timeStamp'];
    _status=json['status'];
  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};
    map['notificationType']=_notificationType;
    map['ideaId']=_ideaId;
    map['ideaTitle']=_ideaTitle;
    map['ideaType']=_ideaType;
    map['timeStamp']=_timeStamp;
    map['status']=_status;

    return map;
  }
}