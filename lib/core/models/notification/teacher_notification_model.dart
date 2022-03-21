class TeacherNotificationModel{
  String? _notificationType;
  String? _ideaId;
  String? _ideaTitle;
  String? _ideaType;



  String? get notificationType => _notificationType;
  String? get ideaId => _ideaId;
  String? get ideaTitle=>_ideaTitle;
  String? get ideaType=>_ideaType;


  TeacherNotificationModel(this._notificationType,this._ideaId,this._ideaTitle,this._ideaType);


  TeacherNotificationModel.fromJson(dynamic json)
  {
    _notificationType=json['notificationType'];
    _ideaId=json['ideaId'];
    _ideaTitle=json['ideaTitle'];
    _ideaType=json['ideaType'];
  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};
    map['notificationType']=_notificationType;
    map['ideaId']=_ideaId;
    map['ideaTitle']=_ideaTitle;
    map['ideaType']=_ideaType;

    return map;
  }
}