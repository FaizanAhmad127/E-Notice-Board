class MarksModel
{
  Map<String,double> _obe2={};
  Map<String,double> _obe3={};
  Map<String,double> _obe4={};
  double _fyp1Viva=0;
  double _fyp2Viva=0;
  int _timeStamp=0;

  MarksModel();


  Map<String,double>  get obe2 => _obe2;

  Map<String,double>  get obe3 => _obe3;

  Map<String,double>  get obe4 => _obe4;

  double get fyp1Viva => _fyp1Viva;

  double get fyp2Viva => _fyp2Viva;

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