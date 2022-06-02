import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/result/result_model.dart';
import 'package:notice_board/core/services/committee/committee_service.dart';
import 'package:notice_board/core/services/user_documents/student_result_service.dart';
import '../../../../core/models/user_authentication/user_signup_model.dart';
import '../../../../core/services/user_documents/user_profile_service.dart';

class CoordinatorResultScreenVm extends ChangeNotifier
{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  List<UserSignupModel> _listOfStudents=[];
  List<UserSignupModel> _listOfTeachers=[];
  List<UserSignupModel> _listOfCommitteeTeachers=[];
  List<UserSignupModel> _listOfCommitteeStudents=[];
  List<String> _selectedTeachersList=[];
  List<String> _selectedStudentsList=[];
  final CommitteeService _committeeService=GetIt.I.get<CommitteeService>();
  //final StudentResultService _resultService=GetIt.I.get<StudentResultService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final Logger _logger=Logger();
  String uid="";
  bool isDispose=false;

  CoordinatorResultScreenVm()
  {
   uid=_firebaseAuth.currentUser!.uid;

        //getCommitteeTeachers().
       // then((value) async{
          getTeachers().then((value)async{
            getStudents();
          });

        //});

  }



  // TODO: change according to new model
  // Future getCommitteeTeachers()async
  // {
  //    try
  //    {
  //      _resultService.getResultDocument().onData((docSnap) async{
  //
  //        if(isDispose==false)
  //          {
  //
  //            ResultModel resultModel=ResultModel.fromJson(docSnap);
  //            Future.forEach(resultModel.teachersList, (teacherUid) async{
  //              await _userProfileService.getProfileDocument(teacherUid.toString(), 'teacher')
  //                  .then((userPModel) {
  //
  //                setListOfCommitteeTeachers=userPModel;
  //
  //              });
  //            });
  //          }
  //
  //
  //      });
  //
  //    }
  //    catch(error)
  //   {
  //     _logger.e('error at getCommitteeTeachers $error');
  //   }
  //
  // }
  Future setCommitteeTeacherStudent()async
  {

    if(selectedTeachersList.isNotEmpty && selectedStudentList.isNotEmpty)
      {
        //only five teacher per committee
        if((listOfCommitteeTeachers.length+selectedTeachersList.length)<=5) {

          ///check if teacher is already in a list or not
          if(listOfCommitteeTeachers.where((element) =>
              selectedTeachersList.contains(element.uid)).isEmpty)
          {
            ///check if student is already in a list or not
            if(listOfCommitteeStudents.where((element) =>
                selectedStudentList.contains(element.uid)).isEmpty)
              {
                await _committeeService.
                setCommitteeDocument(selectedTeachersList, selectedStudentList);
              }
            else
              {
                BotToast.showText(text: 'Student is already in a list');
              }


            // int timeStamp = Timestamp
            //     .now()
            //     .millisecondsSinceEpoch;
            // await _resultService.setResultDocument(uid,
            //     timeStamp, selectedTeachersList);
          }
          else
            {
              BotToast.showText(text: 'Teacher is already in a list');

            }

        }
        else
          {
            BotToast.showText(text: 'Only 5 teacher per committee is allowed');
          }
      }
    else
      {
        BotToast.showText(text: 'Please select at least one item from drop down');
      }
  }
  Future getTeachers()async
  {
     _listOfTeachers=[];


     try
         {
           await _committeeService.getListOfAllTeachersInCommittee().
           then((listOfTeachersAlreadyInCommittee) async{

             await _userProfileService.getAllTeachers().then((teachers) {
               // this array will store common teachers which are already
               //in a committee, and remove it so it wont' add to dropdown
               List<UserSignupModel> nonCommitteeTeacherList=[];
               teachers.forEach((element) {
                 if(!listOfTeachersAlreadyInCommittee.contains(element.uid))
                 {
                   ///dont add teachers to dropdown if they are already part of other committee
                   nonCommitteeTeacherList.add(element);
                 }

               });
               setListOfTeachers=nonCommitteeTeacherList;
             });

           });
         }
         catch(error)
    {
      _logger.e('error at getTeachers/ coordinatorResultScreenVm $error');
    }

  }
  Future getStudents()async
  {
    _listOfStudents=[];
    try
    {
      await _committeeService.getListOfAllStudentsInCommittee().
      then((listOfStudentsAlreadyInCommittee) async{

        await _userProfileService.getAllStudents().then((students) {
          // this array will store common students which are already
          //in a committee, and remove it so it wont' add to dropdown
          List<UserSignupModel> nonCommitteeStudentList=[];
          students.forEach((element) {
            if(listOfStudentsAlreadyInCommittee.contains(element.uid)==false)
            {
              ///dont add students to dropdown if they are already part of other committee
              nonCommitteeStudentList.add(element);
            }
          });
          setListOfStudents=nonCommitteeStudentList;
        });

      });
    }
    catch(error)
    {
      _logger.e('error at getTeachers/ coordinatorResultScreenVm $error');
    }

  }

  List<String> get selectedTeachersList=>_selectedTeachersList;
  List<UserSignupModel> get listOfTeachers=>_listOfTeachers;

  List<String> get selectedStudentList=>_selectedStudentsList;
  List<UserSignupModel> get listOfStudents=>_listOfStudents;

  List<UserSignupModel> get listOfCommitteeTeachers=>_listOfCommitteeTeachers;
  List<UserSignupModel> get listOfCommitteeStudents=>_listOfCommitteeStudents;


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
  set setListOfStudents(List<UserSignupModel> students)
  {

    students.forEach((userModel) {
      if((_listOfCommitteeStudents.where((element) => element.uid==userModel.uid)).isEmpty)
      {
        _listOfStudents.add(userModel);
      }
    });


    notifyListeners();
  }
  set setSelectedTeachersList(List<String> teachers)
  {
    _selectedTeachersList=teachers;
    notifyListeners();
  }
  set setSelectedStudentsList(List<String> students)
  {
    _selectedStudentsList=students;
    notifyListeners();
  }
  // set setListOfCommitteeTeachers(UserSignupModel? teacher)
  // {
  //   if((listOfCommitteeTeachers.where((element) => element.uid==teacher!.uid)).isEmpty)
  //   {
  //     _listOfCommitteeTeachers.add(teacher!);
  //     //BotToast.showText(text: 'Teacher added');
  //   }
  //
  //
  //   notifyListeners();
  // }
  // set setListOfCommitteeStudents(UserSignupModel? student)
  // {
  //   if((listOfCommitteeStudents.where((element) => element.uid==student!.uid)).isEmpty)
  //   {
  //     _listOfCommitteeStudents.add(student!);
  //     //BotToast.showText(text: 'Teacher added');
  //   }
  //
  //
  //   notifyListeners();
  // }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }
}