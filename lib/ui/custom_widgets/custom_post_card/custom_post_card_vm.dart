import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_authentication/user_auth_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class CustomPostCardVM extends ChangeNotifier{
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  String _userName="";
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
      setUserName=_userSignupModel?.fullName??"Unknown";
    }
    catch(error)
    {
      _logger.e("error at CustomPostCardVM /userName.dart $error");

    }



  }

  String get getUserName=>_userName;

  set setUserName(String user)
  {
    _userName=user;
    notifyListeners();
  }

}