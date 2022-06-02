import 'package:notice_board/core/models/idea/comment_model.dart';

class CommitteeModel{

  List<String>? _teacherList;
  List<String>? _studentList;

  List<String>? get teacherList=>_teacherList;
  List<String>? get studentList=>_studentList;

  CommitteeModel(this._studentList,this._teacherList);

  CommitteeModel.fromJson(dynamic json){

    _teacherList=List<String>.from(json['teacherList']??[]);
    _studentList=List<String>.from(json['studentList']??[]);
  }

  Map<String,dynamic> toJson(){

    return {
      'teacherList':teacherList,
      'studentList':studentList
  };
}




}