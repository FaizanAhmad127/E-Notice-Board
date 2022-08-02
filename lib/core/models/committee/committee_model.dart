import 'package:notice_board/core/models/idea/comment_model.dart';

class CommitteeModel{

  late List<String> _teacherList;
  late List<String> _ideaList;

  List<String> get teacherList=>_teacherList;
  List<String> get ideaList=>_ideaList;

  CommitteeModel(this._ideaList,this._teacherList);

  CommitteeModel.fromJson(dynamic json){

    _teacherList=List<String>.from(json['teacherList']??[]);
    _ideaList=List<String>.from(json['ideaList']??[]);
  }

  Map<String,dynamic> toJson(){

    return {
      'teacherList':teacherList,
      'ideaList':ideaList
  };
}




}