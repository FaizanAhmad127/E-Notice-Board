import 'package:cloud_firestore/cloud_firestore.dart';

class MarksModel
{
  Map<String,double> _obe2={};
  Map<String,double> _obe3={};
  Map<String,double> _obe4={};
  double _fyp1Viva=0.0;
  double _fyp2Viva=0.0;
  String _uid='';
  String _isfinalized='';
  String _OBE2Status='';
  int _timeStamp=Timestamp.now().millisecondsSinceEpoch;

  MarksModel(this._uid,this._isfinalized,this._OBE2Status);
 // MarksModel(this._isfinalized);

  String get uid=>_uid;
  String get isfinalized=>_isfinalized;
  String get OBE2Status=>_OBE2Status;

  Map<String,double>  get obe2 => _obe2;

  Map<String,double>  get obe3 => _obe3;

  Map<String,double>  get obe4 => _obe4;

  double get fyp1Viva => _fyp1Viva;

  double get fyp2Viva => _fyp2Viva;

  int get timeStamp => _timeStamp;

  MarksModel.fromJson(dynamic json)
  {
    _uid=json['uid'];
    _OBE2Status=json['OBE2Status'];
    if(json['isfinalized'] != null){
    _isfinalized=json['isfinalized'];
    }else {
      _isfinalized = "no";
    }
    _obe2=Map<String,double>.from(json['obe2']);
    _obe3=Map<String,double>.from(json['obe3']);
    _obe4=Map<String,double>.from(json['obe4']);
    if(json['fyp1Viva'] is int)
      {
        _fyp1Viva=json['fyp1Viva'].toDouble();
      }
    else
      {
        _fyp1Viva=json['fyp1Viva'];
      }
    if(json['fyp2Viva'] is int)
    {
      _fyp2Viva=json['fyp2Viva'].toDouble();
    }
    else
    {
      _fyp2Viva=json['fyp2Viva'];
    }

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
    map['uid']=_uid;
    map['isfinalized']=_isfinalized;
    map['OBE2Status']=_OBE2Status;


    return map;
  }


}