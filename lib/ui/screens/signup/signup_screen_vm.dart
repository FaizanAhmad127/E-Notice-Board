import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/signup_request_model.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/notification/signup_request_service.dart';
import 'package:notice_board/ui/screens/login/login_screen.dart';
import '../../../core/models/user_authentication/user_signup_model.dart';
import '../../../core/services/user_authentication/user_auth_service.dart';
import '../../../core/services/user_documents/user_profile_service.dart';
import '../../../core/services/validate_service.dart';

class SignupScreenVM extends ChangeNotifier
{
  int _groupValue = 0;

  //GetIt is a package used to create singleton design pattern.
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();

  final SignupRequestService _requestService=GetIt.I.get<SignupRequestService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  List<UserSignupModel> _listOfStudents=[];
  List<UserSignupModel> _listOfTeachers=[];
  bool isDispose=false;
  final Logger _logger=Logger();
  List<UserSignupModel> get listOfStudents => _listOfStudents;
  List<UserSignupModel> get listOfTeachers => _listOfTeachers;


  SignupScreenVM()
  {
    getListOfStudents();
    getListOfTeachers();
  }

  set setListOfStudents(List<UserSignupModel> list)
  {
    _listOfStudents=list;
    notifyListeners();
  }
  set setListOfTeachers(List<UserSignupModel> list)
  {
    _listOfTeachers=list;
    notifyListeners();
  }

  Future getListOfStudents()async
  {
    try{
      await _userProfileService.getAllStudents().then((listOfStudents) {
        if(isDispose==false)
        {
          setListOfStudents=listOfStudents;
          //setSearchList=listOfStudents;
        }

      });
    }
    catch(error){
      _logger.e("error at getStudentList/signupvm.dart $error");
    }

  }

  Future getListOfTeachers()async
  {
    try{
      await _userProfileService.getAllTeachers().then((listOfTeachers) {
        if(isDispose==false) {
          setListOfTeachers = listOfTeachers;
          // setSearchList = listOfTeachers;
        }
      });
    }
    catch(error){
      _logger.e("error at getStudentList/signupvm.dart $error");
    }

  }

  void signup(BuildContext context,String email,String password,String confirmPassword, String fullName,String universityId)async
  {
    int dateTime=(DateTime.now().millisecondsSinceEpoch);

    try {
      if (Validate().validateSignup(
          email, password, confirmPassword, fullName, universityId)&& !universityIdNotDuplicated(universityId))
      {
        await _userAuthService.userSignup(email, password).then((uid) async {

          if (uid.isEmpty) {
            BotToast.showText(
                text: "Unable to signup. The email is already registered",
                duration: const Duration(seconds: 3));
          }

          else {

             SignupRequestModel requestModel=SignupRequestModel(
                 fullName, userType(), dateTime, uid, universityId,email)  ;

             _requestService.createSignupRequestDocument(email, requestModel).then((value){

               BotToast.showText(
                   text: "Signup request sent to Coordinator", duration: const Duration(seconds: 4));

               NavigationService().navigatePushReplacement(context, LoginScreen());

             });

          }
        });
      }
    }
    catch(error)
    {
      BotToast.showText(text: "$error");
    }


  }






  int get getGroupValue=>_groupValue;
  
  set setGroupValue(int a)
  {
    _groupValue=a;
    notifyListeners();
  }

  String userType()
  {
    String userType="";
    if(getGroupValue==0)
      {
        userType="student";
      }
    if(getGroupValue==1)
    {
      userType= "teacher";
    }
    return userType;
  }

  bool universityIdNotDuplicated(String universityId) {
    var dupliated = false;
    _listOfStudents.forEach((student)=>{
      if(student.universityId==universityId){
        dupliated = true
      }
    });
    _listOfTeachers.forEach((teacher)=>{
      if(teacher.universityId==universityId){
        dupliated = true
      }
    });

    if(dupliated){
      BotToast.showText(
          text: "Unable to signup. University ID Already exist",
          duration: const Duration(seconds: 3));
    }
    return dupliated;
  }
}