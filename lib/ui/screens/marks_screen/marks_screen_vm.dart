import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/marks_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../core/services/shared_pref_service.dart';

class MarksScreenVM extends ChangeNotifier{
  final TextEditingController _searchTFController=TextEditingController();
  final Logger _logger=Logger();
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  String uid='';
  String userType='';
  ResultModel? resultModel;
  List<MarksModel> listOfAllMarks=[];
  List<UserSignupModel> listOfStudents=[];
  Map<String,MarksModel> studentMarksMap={};
  Map<String,MarksModel> searchedStudentMarksMap={};
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final SharedPref _sharedPref = GetIt.I.get<SharedPref>();
  UserSignupModel? thisUser;


  MarksScreenVM(){
    BotToast.showLoading();
    uid=_firebaseAuth.currentUser!.uid;
    userType=_sharedPref.retrieveString('userType')??"";
    if(userType!='student' && userType!='teacher')
      {
        userType='coordinator';
      }
    getCurrentUser().then((value) {
      getListOfMarks().then((value) {
        getResultDocument();
        mergeStudentWithMarks();


      });
    });
    _searchTFController.addListener(() {
      search();
    });
    BotToast.closeAllLoading();
  }

  Future finalizeResult()async
  {
    await _resultService.finalizeResult();
  }
  void search()
  {
    try {
      searchedStudentMarksMap = {};
      if (_searchTFController.text.isEmpty) {
        searchedStudentMarksMap = studentMarksMap;
      }
      else {
        studentMarksMap.forEach((key, value) {
          if (key.toLowerCase().contains(
              _searchTFController.text.toLowerCase())) {
            searchedStudentMarksMap.addAll({
              key: value
            });
          }
        });
      }

      notifyListeners();
    }
    catch(error)
    {
      _logger.e('error at search / marksscreenvm $error');
    }
  }

  void mergeStudentWithMarks(){
    try {
      for (int index = 0; index < listOfStudents.length; index++) {
        studentMarksMap.addAll(
            {
              listOfStudents[index].fullName ?? "": listOfAllMarks[index]

            }
        );
      }
      searchedStudentMarksMap = studentMarksMap;
      notifyListeners();
    }
    catch(error)
    {
      _logger.e('error at mergeStudentWithMarks/ marksscreenvm  $error');
    }

  }

  Future getCurrentUser()async{
    try {
      await _userProfileService.getProfileDocument(uid, userType).then((
          userModel) {
        thisUser = userModel;
      });
    }
    catch(error)
    {
      _logger.e('error at getCurrentUser / marksscreenvm $error');
    }
  }
  Future getListOfMarks()async
  {
    try {
      await _resultService.getAllStudentMarks().then((listMarks) async {
        listOfAllMarks = listMarks;
        await Future.forEach(listMarks, (MarksModel marksModel) async {
          await _userProfileService.getProfileDocument(
              marksModel.uid, 'student').then((user) {
                if(userType=='student')
                  {
                    if(thisUser?.fullName==user?.fullName)
                    {
                      listOfStudents.add(user!);
                    }
                  }
                else
                  {
                    listOfStudents.add(user!);
                  }


          });
        });
      });
    }
    catch(error)
    {
      _logger.e('error at getListOfMarks / marksscreenvm $error');
    }

  }
  Future getResultDocument()async{
     _resultService.getResultDocument().onData((docSnap) {
      try
          {
            resultModel=ResultModel.fromJson(docSnap);
            notifyListeners();
          }
          catch(error)
       {
         _logger.e('the result document is empty for now  getResultDocument/ marksscreenvm$error');
       }
    });

  }

  TextEditingController get searchTFController=>_searchTFController;

  @override
  void dispose() {
    super.dispose();
    _searchTFController.removeListener(() { });
  }
}