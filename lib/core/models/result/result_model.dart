class ResultModel{

  String? _coordinatorUid;
  String _isResultFinalized='no';
  int? _timeStamp;
 // List<String> _teachersList=[];

  ResultModel(this._coordinatorUid,this._timeStamp,
     // this._teachersList
      );

  String get isResultFinalized => _isResultFinalized;

  int? get timeStamp => _timeStamp;

  String? get coordinatorUid => _coordinatorUid;

 // List<String> get teachersList=>_teachersList;

  ResultModel.fromJson(dynamic json){
    _coordinatorUid=json['coordinatorUid'];
    _isResultFinalized=json['isResultFinalized'];
    _timeStamp=json['timeStamp'];
    //_teachersList=List<String>.from(json['teachersList']);

  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};
    map['coordinatorUid']=_coordinatorUid;
    map['isResultFinalized']=_isResultFinalized;
    map['timeStamp']=_timeStamp;
    //map['teachersList']=_teachersList;
    return map;
  }


}