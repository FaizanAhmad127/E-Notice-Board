import 'package:cloud_firestore/cloud_firestore.dart';

class ReactionModel
{

  ReactionModel(this._type,this._byUid);

  String? _type;
  String? _byUid;
  Timestamp _timestamp=Timestamp.now();


  Timestamp get timestamp => _timestamp;
  String? get byUid => _byUid;
  String? get type => _type;

  ReactionModel.fromJson(dynamic json)
  {
    _type=json['type'];
    _byUid=json['byUid'];
    _timestamp=json['timestamp'];
  }
  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> map={};
    map['type']=_type;
    map['byUid']=_byUid;
    map['timestamp']=_timestamp;
    return map;
  }
}