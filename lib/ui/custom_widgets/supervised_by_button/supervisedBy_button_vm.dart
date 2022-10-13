import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../core/models/user_authentication/user_signup_model.dart';
import '../../../core/services/user_documents/user_profile_service.dart';


class SupervisedByButtonVM extends ChangeNotifier{
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  String _userName="";
  final Logger _logger=Logger();

  SupervisedByButtonVM(String uid)
  {
    userName(uid);
  }
  Future userName(String uid)async
  {
    try{
      UserSignupModel? _userSignupModel;
      _userSignupModel=await _userProfileService.getProfileDocument(uid,"teacher");
      setUserName=_userSignupModel?.fullName??"Unknown";
    }
    catch(error)
    {
      _logger.e("error at SupervisedByButtonVM /userName.dart $error");

    }



  }

  String get getUserName=>_userName;

  set setUserName(String user)
  {
    _userName=user;
    notifyListeners();
  }
}