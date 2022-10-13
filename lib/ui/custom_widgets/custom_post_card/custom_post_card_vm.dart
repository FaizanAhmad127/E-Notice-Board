import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class CustomPostCardVM extends ChangeNotifier{
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  String _userName="";
  String _userID="";
  String _pictureUrl="";
  bool isDispose=false;
  final Logger _logger=Logger();

  CustomPostCardVM(String uid)
  {
    userName(uid);
  }
  Future userName(String uid)async
  {
    try
    {
      UserSignupModel? _userSignupModel;
      _userSignupModel=await _userProfileService.getProfileDocument(uid,"student");
      if(isDispose==false)
        {
          setUserName=_userSignupModel?.fullName??"Unknown";
          setUserID=_userSignupModel?.universityId??"Unknown";
          setPictureUrl=_userSignupModel?.profilePicture??"";
        }


    }
    catch(error)
    {
      _logger.e("error at CustomPostCardVM /userName.dart $error");

    }



  }

  String get getUserName=>_userName;
  String get getUserID=>_userID;
  String get pictureUrl=>_pictureUrl;

  set setUserName(String user)
  {
    _userName=user;
    notifyListeners();
  }
  set setUserID(String user)
  {
    _userID=user;
    notifyListeners();
  }

  set setPictureUrl(String url)
  {
    _pictureUrl=url;
    notifyListeners();
  }
 @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }

}