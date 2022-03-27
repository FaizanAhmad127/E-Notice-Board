import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/constants/strings.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/file_management/file_picker_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:page_transition/page_transition.dart';
import '../../../../../core/services/user_authentication/user_auth_service.dart';
import '../../../login/login_screen.dart';

class CoordinatorDrawerScreenVM extends ChangeNotifier
{
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FilePickerService _filePickerService=FilePickerService();
  bool _isEditButtonClicked=false;
  UserSignupModel? _signupModel;
  String _imageUrl=noImageUrl;
  final Logger _logger=Logger();
  String uid="";


  CoordinatorDrawerScreenVM()
  {
    uid=_firebaseAuth.currentUser!.uid;
    getUserData();
  }

  Future signOut(BuildContext context)async
  {
    try
    {
      await _userProfileService.postOnlineStatus("coordinator", uid, "offline").then((value) {
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
      _logger.e("error at signOut/CoordinatorDrawerScreenVM.dart $error");
    }


  }

  Future getUserData()async
  {
    try
    {

      await _userProfileService.getProfileDocument(uid, "coordinator").then((doc){
        setSignupModel=doc!;
        setImageURL=doc.profilePicture??noImageUrl;
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
          _userProfileService.uploadProfileImage("coordinator", uid, file).then((value){
            setImageURL=value;
          });
        }

      });
    }
    catch(error)
    {
      _logger.e("error at chooseImage/StudentDrawerScreenVM.dart $error");
    }

  }
  Future saveEditedProfile(String name, String occupation)async
  {
    await _userProfileService.updateNameAndOccupation("coordinator", uid,
        name, occupation).then((value){
      getUserData();
    });
  }

  bool get isEditButtonClicked=>_isEditButtonClicked;
  UserSignupModel? get signupModel => _signupModel;
  String get imageUrl=>_imageUrl;




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



  set setIsEditButtonClicked(bool a)
  {
    _isEditButtonClicked=a;
    notifyListeners();
  }


}