import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../../core/services/user_documents/user_profile_service.dart';

class CoordinatorResultScreenVm extends ChangeNotifier
{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  List<UserSignupModel> _listOfTeachers=[];
  List<UserSignupModel> _listOfCommitteeTeachers=[];
  List<String> _selectedTeachersList=[];
  StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final Logger _logger=Logger();
  String uid="";
  bool isDispose=false;

  CoordinatorResultScreenVm()
  {
    uid=_firebaseAuth.currentUser!.uid;
    getCommitteeTeachers();


  }


  Future getCommitteeTeachers()async
  {
     try
     {
       _resultService.getResultDocument().onData((docSnap) async{

         if(isDispose==false)
           {
             ResultModel resultModel=ResultModel.fromJson(docSnap);
             Future.forEach(resultModel.teachersList, (teacherUid) async{
               await _userProfileService.getProfileDocument(teacherUid.toString(), 'teacher')
                   .then((userPModel) {

                 setListOfCommitteeTeachers=userPModel;

               });
             }).then((value) async{
               await getTeachers();
             });
           }


       });

     }
     catch(error)
    {
      _logger.e('error at getCommitteeTeachers $error');
    }

  }
  Future setCommitteeTeacher()async
  {

    if(selectedTeachersList.isNotEmpty)
      {

        int timeStamp=Timestamp.now().millisecondsSinceEpoch;
          await _resultService.setResultDocument(uid,
              timeStamp, selectedTeachersList);

      }
    else
      {
        BotToast.showText(text: 'Please select at least one teacher');
      }
  }
  Future getTeachers()async
  {
     _listOfTeachers=[];
    await _userProfileService.getAllTeachers().then((teachers) {
      setListOfTeachers=teachers;
    });
  }

  List<String> get selectedTeachersList=>_selectedTeachersList;
  List<UserSignupModel> get listOfTeachers=>_listOfTeachers;
  List<UserSignupModel> get listOfCommitteeTeachers=>_listOfCommitteeTeachers;

  set setListOfTeachers(List<UserSignupModel> teachers)
  {

    teachers.forEach((userModel) {
      if((listOfCommitteeTeachers.where((element) => element.uid==userModel.uid)).isEmpty)
        {
          _listOfTeachers.add(userModel);
        }
    });


    notifyListeners();
  }
  set setSelectedTeachersList(List<String> teachers)
  {
    _selectedTeachersList=teachers;
    notifyListeners();
  }
  set setListOfCommitteeTeachers(UserSignupModel? teacher)
  {
    if((listOfCommitteeTeachers.where((element) => element.uid==teacher!.uid)).isEmpty)
    {
      _listOfCommitteeTeachers.add(teacher!);
    }
    else
      {
        BotToast.showText(text: 'Teacher already in a list');
      }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    print('disposed is called');
    isDispose=true;
  }
}