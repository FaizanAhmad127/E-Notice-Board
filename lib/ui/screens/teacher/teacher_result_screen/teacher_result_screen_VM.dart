import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
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
  List<IdeaModel> ideaList=[];
  TeacherResultScreenVM(){
  uid=_firebaseAuth.currentUser!.uid;
  getStudentGroups();
  }

  Future getStudentGroups()async
  {
     ResultModel? resultModel;
     _resultService.getResultDocument().onData((resultDoc) async{
       try
       {
         resultModel=ResultModel.fromJson(resultDoc);
       }
       catch(error)
       {
         print('result model is null becuase there is no result document or any field is missing, it can happen '
             'when not a single teacher is selected in a committee'
             ' getStudentGroup/ teacher_result_screen_vm $error');
       }
       if(resultModel!=null)
         {
           if(resultModel!.teachersList.contains(uid))
           {

             await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) {
               listOfIdeas.forEach((idea) async{
                 List<UserSignupModel> userList=[];
                 await Future.forEach(idea.students, (studentUID) async{
                   await _userProfileService.
                   getProfileDocument(
                       studentUID.toString(),
                       'student').then((user) {
                     userList.add(user!);
                   });
                 });
                 setGroups=userList;
                 ideaList.add(idea);

               });
             });
           }
           else
             {
               await getAcceptedIdeasOfThisTeacher();
             }
         }

      else
        {
          await getAcceptedIdeasOfThisTeacher();
        }
    });

  }

  Future getAcceptedIdeasOfThisTeacher()async
  {
    await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) async{
      listOfIdeas.forEach((idea) async{
        List<UserSignupModel> userList=[];
        if(idea.acceptedBy==uid)
        {

          await Future.forEach(idea.students, (studentUID) async{
            await _userProfileService.
            getProfileDocument(
                studentUID.toString(),
                'student').then((user) {
              userList.add(user!);
            });
          });
          setGroups=userList;
          ideaList.add(idea);
        }



      });
    });
  }

  List<List<UserSignupModel>> get groups=>_groups;

  set setGroups(List<UserSignupModel> group)
  {
    _groups.add(group);
    notifyListeners();
  }
}