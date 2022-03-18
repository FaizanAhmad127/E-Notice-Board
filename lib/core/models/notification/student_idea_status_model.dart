class StudentIdeaStatusModel
{
  String? _ideaId;
  String? _ideaTitle;
  String? _status;
  int? _timeStamp;
  String? _teacherName;

  StudentIdeaStatusModel(this._ideaId,this._ideaTitle,this._status,this._timeStamp,this._teacherName);

  String? get ideaId => _ideaId;

  String? get ideaTitle => _ideaTitle;

  String? get status => _status;

  int? get timeStamp => _timeStamp;

  String? get teacherName => _teacherName;

  StudentIdeaStatusModel.fromJson(dynamic json)
  {
    _ideaId=json['ideaId'];
    _ideaTitle=json['ideaTitle'];
    _status=json['status'];
    _timeStamp=json['timeStamp'];
    _teacherName=json['teacherName'];
  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};

    map['ideaId']=_ideaId;
    map['ideaTitle']=_ideaTitle;
    map['status']=_status;
    map['timeStamp']=_timeStamp;
    map['teacherName']=_teacherName;

    return map;
  }
}