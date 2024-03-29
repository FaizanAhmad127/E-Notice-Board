import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';

import '../../../../core/models/idea/idea_model.dart';
import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../../core/services/committee/committee_service.dart';

class TeacherMarksScreenVM extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
  bool _isCommitteeMember=false;
  String uid="";
  bool isDispose=false;
  bool _isSupervisor=false;
  List<String> _dropDownListItems=[];
  String _selectedDropDownListItem="";
  List<UserSignupModel> group=[];
  List<double> marks=[];
  IdeaModel? idea;
  Map<String,Map<String,dynamic>> _marksListMap={};

  TeacherMarksScreenVM({required this.group,required this.idea})
  {
    uid=_firebaseAuth.currentUser!.uid;
    getNoOfStudents();
    checkIfThisTeacherIsSupervisor();
    group.forEach((element) {
      _marksListMap.addAll({
          element.uid??"":{
        'uid':element.uid,
        'exam':'',
         'marks':0.0,
      }});
    });
    getCommitteeDocument();
    //getResultDocument();
  }
  void getNoOfStudents()
  {
    marks.clear();
    for(int i=0;i<group.length;i++)
    {
      marks.add(101);
    }

  }
  void checkIfThisTeacherIsSupervisor()
  {
     setIsSupervisor=idea!.teachers.contains(uid);
  }


  void resetMarksListMap(String exam)
  {
    group.forEach((element) {
      _marksListMap[element.uid??""]!['exam']=exam;

    });
    print(_marksListMap.entries);
    notifyListeners();
  }
  Future submitMarks()async
  {
      BotToast.showLoading();
        await _resultService.setStudentMarks(_marksListMap, uid);
     BotToast.closeAllLoading();

  }

  Future getCommitteeDocument()async
  {
    CommitteeModel? committeeModel;

    try
    {
      await _committeeService.getTeacherCommittee(uid).then((committeeModel) {
        setIsCommitteeMember=committeeModel!.ideaList.contains(idea!.ideaId);
      });

    }
    catch(error)
    {
      print('committee model is null because there is no committee'
          ' document or any field is missing getCommitteeDocument/ teacher_marks_screen_vm $error');
      setIsCommitteeMember=false;
    }
    if(committeeModel!=null)
      {
        setIsCommitteeMember=true;
      }
    if(isDispose==false)
    {
      if(isCommitteeMember==true && isSupervisor==true)
      {
        setdropDownListItems=['OBE2','OBE3','OBE4','FYP-1 VIVA','FYP-2 VIVA'];
        setSelectedDropDownListItem='OBE2';
        resetMarksListMap('OBE2');
      }
      else if(isCommitteeMember==true && isSupervisor==false)
      {
        setdropDownListItems=['OBE2','OBE3','OBE4',];
        setSelectedDropDownListItem='OBE2';
        resetMarksListMap('OBE2');
      }
      else
      {
        setdropDownListItems=['FYP-1 VIVA','FYP-2 VIVA'];
        setSelectedDropDownListItem='FYP-1 VIVA';
        resetMarksListMap('FYP-1 VIVA');
      }
    }

  }

  // Future getResultDocument()async
  // {
  //    _resultService.getResultDocument().onData((resultDocSnap) {
  //      ResultModel? resultModel;
  //
  //     try
  //     {
  //       resultModel=ResultModel.fromJson(resultDocSnap);
  //     }
  //     catch(error)
  //     {
  //       print('result model is null becuase there is no result document or any field is missing getResultDocument/ teacher_marks_screen_vm $error');
  //       setIsCommitteeMember=false;
  //     }
  //
  //     if(resultModel!=null)
  //       {
  //         setIsCommitteeMember=resultModel.teachersList.contains(uid);
  //       }
  //
  //      if(isDispose==false)
  //      {
  //        if(isCommitteeMember==true && isSupervisor==true)
  //        {
  //          setdropDownListItems=['OBE2','OBE3','OBE4','FYP-1 VIVA','FYP-2 VIVA'];
  //          setSelectedDropDownListItem='OBE2';
  //          resetMarksListMap('OBE2');
  //        }
  //        else if(isCommitteeMember==true && isSupervisor==false)
  //        {
  //          setdropDownListItems=['OBE2','OBE3','OBE4',];
  //          setSelectedDropDownListItem='OBE2';
  //          resetMarksListMap('OBE2');
  //        }
  //        else
  //        {
  //          setdropDownListItems=['FYP-1 VIVA','FYP-2 VIVA'];
  //          setSelectedDropDownListItem='FYP-1 VIVA';
  //          resetMarksListMap('FYP-1 VIVA');
  //        }
  //      }
  //
  //
  //
  //   });
  // }

  String get selectedDropDownListItem=>_selectedDropDownListItem;
  bool get isCommitteeMember=>_isCommitteeMember;
  bool get isSupervisor=>_isSupervisor;
  List<String> get dropDownListItems=>_dropDownListItems;
  Map<String,Map<String,dynamic>> get  marksListMap =>_marksListMap;

  void setMarksListMap(String exam, double marks, String uid )
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

   set setIsSupervisor(bool a)
   {
     _isSupervisor=a;
     notifyListeners();
   }
   set setIsCommitteeMember(bool a)
   {
     _isCommitteeMember=a;
     notifyListeners();
   }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }
}