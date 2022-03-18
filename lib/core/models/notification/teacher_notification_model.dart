class TeacherNotificationModel{
  String? _notificationType;
  String? _ideaId;


  String? get notfType => _notificationType;
  String? get ideaId => _ideaId;


  TeacherNotificationModel(this._notificationType,this._ideaId);


  TeacherNotificationModel.fromJson(dynamic json)
  {
    _notificationType=json['notificationType'];
    _ideaId=json['ideaId'];
  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};
    map['notificationType']=_notificationType;
    map['ideaId']=_ideaId;

    return map;
  }
}