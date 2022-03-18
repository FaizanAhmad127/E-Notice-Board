import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../../core/services/user_authentication/user_auth_service.dart';
import '../../../login/login_screen.dart';

class DrawerScreenVM extends ChangeNotifier
{
  final UserAuthService _userAuthService=GetIt.I.get<UserAuthService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  bool _isEditButtonClicked=false;

  Future signOut(BuildContext context)async
  {

      await _userProfileService.postOnlineStatus("student", _userAuthService.uid, "offline").then((value) {
        _userAuthService.userSignOut().then((value) {
          Navigator.pushReplacement(context, PageTransition(
              duration: const Duration(milliseconds: 700),
              type: PageTransitionType.leftToRightWithFade, child: LoginScreen(
          )));
        });
      });



  }

  bool get isEditButtonClicked=>_isEditButtonClicked;

  set setIsEditButtonClicked(bool a)
  {
    _isEditButtonClicked=a;
    notifyListeners();
  }
}