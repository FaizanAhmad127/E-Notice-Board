import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/constants/strings.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/file_management/file_picker_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/services/user_authentication/user_auth_service.dart';
import '../../../login/login_screen.dart';

class StudentDrawerScreenVM extends ChangeNotifier
{
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final StudentIdeaService _ideaService=GetIt.I.get<StudentIdeaService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FilePickerService _filePickerService=FilePickerService();
  bool _isEditButtonClicked=false;
  UserSignupModel? _signupModel;
  List<IdeaModel>? _listOfIdeas=[];
   String _imageUrl=noImageUrl;
   String _fullNameValue="";
  String _occupationValue="";




  final Logger _logger=Logger();
  String uid="";

  StudentDrawerScreenVM()
  {
    uid=_firebaseAuth.currentUser!.uid;
    getUserData();
    getUserIdeas();
  }

  Future signOut(BuildContext context)async
  {
    try
    {
      await _userProfileService.postOnlineStatus("student", uid, "offline").then((value) {
        _userAuthService.userSignOut().then((value) {
          Navigator.pushReplacement(context, PageTransition(
              duration: const Duration(milliseconds: 700),
              type: PageTransitionType.leftToRightWithFade, child: LoginScreen(
          )));
        });
      });
    }
    catch(error)
    {
      _logger.e("error at signOut/DrawerScreenVM.dart $error");
    }


  }

  Future getUserData()async
  {
    try
    {

      await _userProfileService.getProfileDocument(uid, "student").then((doc){
        setSignupModel=doc!;
        setFullNameValue=doc.fullName!;
        setOccupationValue=doc.occupation!;
        setImageURL=doc.profilePicture!;
      });
    }
    catch(error)
    {
      _logger.e("error at getUserData/DrawerScreenVM.dart $error");
    }

  }

  Future getUserIdeas()async
  {
    try
    {

      await _ideaService.getAllUserIdeas(uid).then((ideasLst){
        setListOfIdeas=ideasLst;
      });
    }
    catch(error)
    {
      _logger.e("error at getUserData/DrawerScreenVM.dart $error");
    }

  }

  Future chooseImage()async{
    try{
      await _filePickerService.imagePicker().then((file) {
        if(file.existsSync()==true)
          {
            _userProfileService.uploadProfileImage("student", uid, file).then((value){
              setImageURL=value;
            });
          }

      });
    }
    catch(error)
    {
      _logger.e("error at chooseImage/DrawerScreenVM.dart $error");
    }

  }
  Future saveEditedProfile(String name, String occupation)async
  {
     await _userProfileService.updateNameAndOccupation("student", uid,
         name, occupation).then((value){
           getUserData();
     });
  }

  bool get isEditButtonClicked=>_isEditButtonClicked;
  UserSignupModel? get signupModel => _signupModel;
  List<IdeaModel>? get listOfIdeas => _listOfIdeas;
  String get imageUrl=>_imageUrl;
  String get fullNameValue => _fullNameValue;
  String get occupationValue => _occupationValue;

  set setFullNameValue(String name)
  {
    _fullNameValue=name;
    notifyListeners();
  }
  set setOccupationValue(String occupation)
  {
    _occupationValue=occupation;
    notifyListeners();
  }

  set setImageURL(String s)
  {
    _imageUrl=s;
    notifyListeners();
  }

  set setSignupModel(UserSignupModel user)
  {
    _signupModel=user;
    notifyListeners();
  }

  set setListOfIdeas(List<IdeaModel> ideasList)
  {
    _listOfIdeas=ideasList;
    notifyListeners();
  }

  set setIsEditButtonClicked(bool a)
  {
    _isEditButtonClicked=a;
    notifyListeners();
  }


}