import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';

class UserProfileService{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();

  Future createProfileDocument({required String userType,required UserSignupModel userSignupModel})async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseFirestore.collection(userType).add(userSignupModel.toJson()).then((value) {
      });
    }
    catch(error)
    {
      _logger.e("error at createProfileDocument services/UserProfileService.dart");
    }
    BotToast.closeAllLoading();

  }
}