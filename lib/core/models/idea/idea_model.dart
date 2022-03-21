import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notice_board/core/models/idea/file_model.dart';

class IdeaModel{


  String _ideaId="";
  String _ideaType="";
  String _ideaTitle="";
  String _ideaDescription="";
  int _timestamp=1;
  String _ideaOwner="";
  int _noOfTeachers=0;
  int _rejectedTimes=0;
  String _status="pending";
  String _acceptedBy="";
  List<String> _students=[];
  List<String> _teachers=[];
  List<FileModel> _filesList=[];
  IdeaModel(
      this._ideaId,
      this._ideaType,
      this._ideaTitle,
      this._ideaDescription,
      this._ideaOwner,
      this._noOfTeachers,
      this._students,
      this._teachers,
      this._filesList,
      this._timestamp);

  String get ideaType => _ideaType;
  String get ideaTitle => _ideaTitle;
  String get ideaDescription => _ideaDescription;
  String get ideaOwner => _ideaOwner;
  String get ideaId => _ideaId;
  int get noOfTeachers => _noOfTeachers;
  int get rejectedTimes => _rejectedTimes;
  String get status => _status;
  String get acceptedBy => _acceptedBy;
  int get timestamp => _timestamp;
  List<String> get students => _students;
  List<String> get teachers => _teachers;
  List<FileModel> get filesList => _filesList;

  IdeaModel.fromJson(dynamic json){
    _ideaId=json['ideaId'];
    _ideaType=json['ideaType'];
    _ideaTitle=json['ideaTitle'];
    _ideaDescription=json['ideaDescription'];
    _timestamp=json['timeStamp'];
    _ideaOwner=json['ideaOwner'];
    _noOfTeachers=json['noOfTeachers'];
    _rejectedTimes=json['rejectedTimes'];
    _status=json['status'];
    _acceptedBy=json['acceptedBy'];
    _timestamp=json['timeStamp'];
    _students=List<String>.from(json['students']);
    _teachers=List<String>.from(json['teachers']);

    Iterable list=json['filesList'];
    _filesList = list.map((i) =>
        FileModel.fromJson(i)).toList();

  }

  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['ideaId']=_ideaId;
    map['ideaType']=_ideaType;
    map['ideaTitle']=_ideaTitle;
    map['ideaDescription']=_ideaDescription;
    map['timeStamp']=_timestamp;
    map['ideaOwner']=_ideaOwner;
    map['noOfTeachers']=_noOfTeachers;
    map['rejectedTimes']=_rejectedTimes;
    map['acceptedBy']=_acceptedBy;
    map['status']=_status;
    map['students']=_students;
    map['teachers']=_teachers;
    List<Map<String,dynamic>> fileMapList=[];
    _filesList.forEach((element) {
      fileMapList.add(
          {
            'fileName':element.fileName,
            'fileExtension':element.fileExtension,
            'fileUrl':element.fileUrl,
            'fileSize':element.fileSize,
          }
      );
    });
    map['filesList']=fileMapList;



    return map;

  }
}