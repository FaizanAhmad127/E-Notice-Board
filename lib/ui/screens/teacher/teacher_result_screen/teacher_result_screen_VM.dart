import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/committee/committee_model.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/committee/committee_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';


class TeacherResultScreenVM extends ChangeNotifier{
  final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
  final StudentIdeaService _studentIdeaService=GetIt.I.get<StudentIdeaService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  final Logger _logger=Logger();
  String uid="";
  List<List<UserSignupModel>> _groups=[];
  List<IdeaModel?> ideaList=[];

  TeacherResultScreenVM(){
  uid=_firebaseAuth.currentUser!.uid;
  getStudentGroups();
  }

  Future getStudentGroups()async
  {
    CommitteeModel? _committeeModel;
    try
    {
      await _committeeService.getTeacherCommittee(uid).then((committeeModel)
      {
         _committeeModel=committeeModel;

      });
    }
    catch(error){
      _logger.e('error at getStudentGroups/ TeacherResultScreenVm , committee model is not setup yet $error');
    }
    if(_committeeModel!=null)
      {
        try
        {
          await Future.forEach(_committeeModel!.ideaList, (String ideaId) async{

            ///getting list of ideas
           await _studentIdeaService.getIdea(ideaId).then((ideaModel)async{

              List<UserSignupModel> userList=[];
              ///getting groups
             await Future.forEach(ideaModel!.students, (String studentUid) async{
               await _userProfileService.getProfileDocument(studentUid, 'student')
                   .then((user){
                 userList.add(user!);
               });

             });
              setGroups=userList;
              ideaList.add(ideaModel);
            });


          }).then((value)async{
            await getAcceptedIdeasOfThisTeacher();
          });
        }
        catch(error){
          _logger.e('error at getStudentGroups/ TeacherResultScreenVm , committee model is not setup yet $error');
        }

      }
    else
      {
        await getAcceptedIdeasOfThisTeacher();
      }


  }

  Future getAcceptedIdeasOfThisTeacher()async
  {
    await _studentIdeaService.getAllAcceptedIdeas().then((listOfIdeas) async{
      listOfIdeas.forEach((idea) async{
        if(ideaList.where((element) => element!.ideaId==idea.ideaId).isEmpty)
        {
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