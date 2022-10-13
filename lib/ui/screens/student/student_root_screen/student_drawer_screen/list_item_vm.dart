import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class ListItemVm extends ChangeNotifier
{
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();

  Future<UserSignupModel?> getTeacherDetails(String uid)async
   {
     UserSignupModel? userSignupModel=await _userProfileService.getProfileDocument(uid, "teacher");
    return userSignupModel;
   }
}