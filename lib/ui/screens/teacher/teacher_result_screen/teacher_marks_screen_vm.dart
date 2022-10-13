import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';

import '../../../../core/models/idea/idea_model.dart';
import '../../../../core/models/notification/student_idea_status_model.dart';
import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../../core/services/committee/committee_service.dart';
import '../../../../core/services/notification/student_idea_status_service.dart';
import '../../../../core/services/user_documents/user_profile_service.dart';

class TeacherMarksScreenVM extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
  bool _isCommitteeMember=false;
  bool _isConvenerMember=false;
  String uid="";
  bool isDispose=false;
  bool _isSupervisor=false;
  List<String> _dropDownListItems=[];
  List<String> _decisionDropDownListItems=[];
  String _selectedDropDownListItem="OBE2";
  String _selectedDecisionDropDownListItem="Accept";
  List<UserSignupModel> group=[];
  List<double> marks=[];
  IdeaModel? idea;
  UserSignupModel? thisTeacher;
  Map<String,Map<String,dynamic>> _marksListMap={};

  TeacherMarksScreenVM({required this.group,required this.idea})
  {
    uid=_firebaseAuth.currentUser!.uid;
    print("objectuid ${uid}");
    thisTeacherDetails();
    notifyListeners();
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
  final StudentIdeaStatusService _studentIdeaStatusService=GetIt.I.get<StudentIdeaStatusService>();
  Future<void> setOBE2Result (String uid, String status, String text) async {
    await _resultService.setStudentOBE2Status(uid,status);
    addRemarks(uid,text,status);
  }
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future addRemarks(String stdID,String remark, String status)async
  {
    int timeStamp = Timestamp
        .now().microsecondsSinceEpoch;
    List<String> stdIDList = [];
    stdIDList.add(stdID);
    try{

      await _studentIdeaStatusService.postNotification(
          stdIDList,
          StudentIdeaStatusModel(
              idea?.ideaId, idea?.ideaTitle,remark,
              status, timeStamp, thisTeacher?.fullName ?? ""));




    }
    catch(error){
      print("error at getListOfTeachers/TeacherStudentListScreenVM.dart $error");
    }

  }

  Future thisTeacherDetails()async
  {
    try
    {
      thisTeacher=await _userProfileService.getProfileDocument(uid, "teacher");
    }
    catch(error)
    {
      print("error at thisTeacherDetails/teacherNotificationScreenVM $error");
    }
  }



  void resetMarksListMap(String exam)
  {
    group.forEach((element) {
      _marksListMap[element.uid??""]!['exam']=exam;

    });
    print(_marksListMap.entries);
    notifyListeners();
  }
  Future submitMarks(String text)async
  {
      BotToast.showLoading();
        await _resultService.setStudentMarks(_marksListMap, uid);
      for( var groupMember in group){
        if(selectedDecisionDropDownListItem.trim().isNotEmpty&&selectedDropDownListItem=="OBE2"&& isConvenerMember ) {
          setOBE2Result( groupMember.uid ?? '',selectedDecisionDropDownListItem,text);
        }
      }
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
      await _committeeService.getTeacherConvener(uid).then((committeeModel) {
        for (var model in committeeModel) {
        setIsConvenerMember=model!.ideaList.contains(idea!.ideaId);
        }
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

      if(isConvenerMember){
        setDecisionDropDownListItems=['Accept','Conditionally accept','Reappear','Reject'];
      }
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
  String get selectedDecisionDropDownListItem=>_selectedDecisionDropDownListItem;
  bool get isCommitteeMember=>_isCommitteeMember;
  bool get isConvenerMember=>_isConvenerMember;
  bool get isSupervisor=>_isSupervisor;
  List<String> get dropDownListItems=>_dropDownListItems;
  List<String> get decisionDropDownListItems=>_decisionDropDownListItems;
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
  set setDecisionDropDownListItems(List<String> itemsList)
  {
    _decisionDropDownListItems=itemsList;
    notifyListeners();
  }

  set setSelectedDropDownListItem(String itemName)
  {
    _selectedDropDownListItem=itemName;
    notifyListeners();
    resetMarksListMap(_selectedDropDownListItem);
  }
  set setSelectedDecisionDropDownListItem(String itemName)
  {
    _selectedDecisionDropDownListItem=itemName;
    notifyListeners();
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
   set setIsConvenerMember(bool a)
   {
     _isConvenerMember=a;
     //print("mathched convener sahab "+ a.toString());
     notifyListeners();
   }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }
}