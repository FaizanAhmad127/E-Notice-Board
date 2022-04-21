import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';

class TeacherMarksScreenVM extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  bool isCommitteeMember=false;
  String uid="";
  bool isDispose=false;
  List<String> _dropDownListItems=[];
  String _selectedDropDownListItem="";
  List<UserSignupModel> group;
  Map<String,Map<String,dynamic>> _marksListMap={};

  TeacherMarksScreenVM({required this.group})
  {
    group.forEach((element) {
      _marksListMap.addAll({
          element.uid??"":{
        'uid':element.uid,
        'exam':'',
         'marks':0,
      }});
    });
    print(_marksListMap.entries);

    uid=_firebaseAuth.currentUser!.uid;
    getResultDocument();
  }
  void resetMarksListMap(String exam)
  {
    group.forEach((element) {
      _marksListMap.addAll({
        element.uid??"":{
          'uid':element.uid,
          'exam':exam,
          'marks':0,
        }});
    });
    print(_marksListMap.entries);
    notifyListeners();
  }
  Future getResultDocument()async
  {
     _resultService.getResultDocument().onData((resultDocSnap) {
      ResultModel resultModel=ResultModel.fromJson(resultDocSnap);
      isCommitteeMember=resultModel.teachersList.contains(uid);
      if(isCommitteeMember==true)
        {
          setdropDownListItems=['OBE2','OBE3','OBE4','FYP-1 VIVA','FYP-2 VIVA'];
          setSelectedDropDownListItem='OBE2';
          resetMarksListMap('OBE2');
        }
      else
        {
          setdropDownListItems=['FYP-1 VIVA','FYP-2 VIVA'];
          setSelectedDropDownListItem='FYP-1 VIVA';
          resetMarksListMap('FYP-1 VIVA');
        }


    });
  }

  String get selectedDropDownListItem=>_selectedDropDownListItem;
  List<String> get dropDownListItems=>_dropDownListItems;
  Map<String,Map<String,dynamic>> get  marksListMap =>_marksListMap;

  void setMarksListMap(String exam, int marks, String uid )
  {
    _marksListMap[uid]={
      'uid':uid,
      'exam':exam,
      'marks': marks,
    };
    print(_marksListMap.entries);
    notifyListeners();
  }

  set setdropDownListItems(List<String> itemsList)
  {
    _dropDownListItems=itemsList;
    notifyListeners();
  }

  set setSelectedDropDownListItem(String itemName)
  {
    _selectedDropDownListItem=itemName;
    resetMarksListMap(_selectedDropDownListItem);
  }


  @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }
}