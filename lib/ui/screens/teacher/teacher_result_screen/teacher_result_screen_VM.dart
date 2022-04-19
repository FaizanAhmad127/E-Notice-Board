import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';


class TeacherResultScreenVM extends ChangeNotifier{
  final StudentIdeaService _studentIdeaService=GetIt.I.get<StudentIdeaService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  String uid="";
  List<List<UserSignupModel>> _groups=[];
  TeacherResultScreenVM(){
  uid=_firebaseAuth.currentUser!.uid;
  getStudentGroups();
  }

  Future getStudentGroups()async
  {

     _resultService.getResultDocument().onData((resultDoc) async{
      if(ResultModel.fromJson(resultDoc).teachersList.contains(uid))
        {
          await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) {
            listOfIdeas.forEach((idea) {
              List<UserSignupModel> userList=[];
                Future.forEach(idea.students, (studentUID) async{
                  await _userProfileService.
                  getProfileDocument(
                      studentUID.toString(),
                      'student').then((user) {
                    userList.add(user!);
                  });
                });
                setGroups=userList;

            });
          });
        }
      else
        {
          await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) {
            listOfIdeas.forEach((idea) {
              List<UserSignupModel> userList=[];
              if(idea.acceptedBy==uid)
              {

                Future.forEach(idea.students, (studentUID) async{
                  await _userProfileService.
                  getProfileDocument(
                      studentUID.toString(),
                      'student').then((user) {
                    userList.add(user!);
                  });
                });
                setGroups=userList;
              }



            });
          });
        }
    });

  }

  List<List<UserSignupModel>> get groups=>_groups;

  set setGroups(List<UserSignupModel> group)
  {
    _groups.add(group);
    notifyListeners();
  }
}