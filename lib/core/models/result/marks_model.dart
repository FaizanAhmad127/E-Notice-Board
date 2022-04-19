class MarksModel
{
  String _obe2='Pending';
  String _obe3='Pending';
  String _obe4='Pending';
  String _fyp1Viva='Pending';
  String _fyp2Viva='Pending';
  int _timeStamp=0;

  MarksModel();


  String get obe2 => _obe2;

  String get obe3 => _obe3;

  String get obe4 => _obe4;

  String get fyp1Viva => _fyp1Viva;

  String get fyp2Viva => _fyp2Viva;

  int get timeStamp => _timeStamp;

  MarksModel.fromJson(dynamic json)
  {
    _obe2=json['obe2'];
    _obe3=json['obe3'];
    _obe4=json['obe4'];
    _fyp1Viva=json['fyp1Viva'];
    _fyp2Viva=json['fyp2Viva'];
    _timeStamp=json['timeStamp'];

  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};

    map['obe2']=_obe2;
    map['obe3']=_obe3;
    map['obe4']=_obe4;
    map['fyp1Viva']=_fyp1Viva;
    map['fyp2Viva']=_fyp2Viva;
    map['timeStamp']=_timeStamp;


    return map;
  }


}