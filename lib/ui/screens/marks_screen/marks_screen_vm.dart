import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/marks_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../core/models/idea/idea_model.dart';
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
  List<IdeaModel> _ideasList=[];
  List<String> studentIdeasList=[];
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final SharedPref _sharedPref = GetIt.I.get<SharedPref>();
  UserSignupModel? thisUser;
  List<List<UserSignupModel>> groups= [];


  MarksScreenVM(List<List<UserSignupModel>> groups){
    BotToast.showLoading();
    this.groups.addAll(groups);
    uid=_firebaseAuth.currentUser!.uid;
    userType=_sharedPref.retrieveString('userType')??"";
    if(userType!='student' && userType!='teacher')
      {
        userType='coordinator';
      }
    listOfIdeas().then((value) => {
      getCurrentUser().then((value) {
        getListOfMarks().then((value) {
          //getResultDocument();
          mergeStudentWithMarks();


        });
      })
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
bool isresultFinaLized = true;
  void mergeStudentWithMarks(){
    try {
      for (int index = 0; index < listOfStudents.length; index++) {
        studentMarksMap.addAll(
            {
              listOfStudents[index].fullName ?? "": listOfAllMarks[index]

            }

        );
        if(listOfAllMarks[index].isfinalized=="no"){
          isresultFinaLized = false;
        }
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

        await Future.forEach(listMarks, (MarksModel marksModel) async {
          await _userProfileService.getProfileDocument(
              marksModel.uid, 'student').then((user) {
            if(userType=='student')
            {

              if(thisUser?.uid==user?.uid)
              {
                listOfAllMarks.add(marksModel);
                listOfStudents.add(user!);
                getStudentIdea(marksModel.uid);

              }
            }
            else
            {
              if(getonlyThisTeacherResult(marksModel.uid)){
                listOfAllMarks.add(marksModel);
              listOfStudents.add(user!);
              getStudentIdea(marksModel.uid);
              }
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
  void getStudentIdea(String? uid) {
    for(var idea in getIdeasList){
      for(var studentID in idea.students){
        if(studentID == uid){
          studentIdeasList.add(idea.ideaTitle);
        }
      }
    }
  }
  bool getonlyThisTeacherResult(String? uid) {
    var isMatched = false;
    if( userType=='teacher'){
    for(var idea in groups){
      for(var teacherID in idea){
        if(teacherID.uid == uid){

          isMatched = true;
        }
      }
      }
    }
    return isMatched;
  }
  List<IdeaModel> get getIdeasList=>_ideasList;
  set setIdeasList(List<IdeaModel> ideas)
  {
    _ideasList=ideas;
    notifyListeners();
  }
  Future listOfIdeas()async
  {
    IdeaModel ideaModel;

    try {
      _firebaseFirestore.collection("post")
          .snapshots().listen((querySnap) {
        _ideasList=[];
        for (var docSnap in querySnap.docs) {
          ideaModel=IdeaModel.fromJson(docSnap);

          _ideasList.add(ideaModel);

        }
        setIdeasList = _ideasList;
        print("indea size"+ _ideasList.length.toString());
      });
    }
    catch(error)
    {
      _logger.e("error at listOfIdeas /coordinatorfinalized marks screen.dart $error");

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