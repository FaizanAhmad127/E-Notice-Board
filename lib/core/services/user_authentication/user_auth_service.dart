import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  String uid="";
  final _logger=Logger();

  Future<String> userLogin(String _email, String _password)async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password)
      .then((value) {
        uid=value.user!.uid;
        _logger.d("uid is $uid");
      });
    }
    catch(error)
    {
      _logger.e("Error at userLogin method, services/UserAuthService.dart $error");
    }
    BotToast.closeAllLoading();
    return uid;
  }
  Future<String> userSignup(String _email, String _password)async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password)
      .then((value) {
        uid=value.user!.uid;
      });
    }
    catch(error)
    {
      _logger.e("Error at userLogin method, services/UserAuthService.dart $error");
    }
    BotToast.closeAllLoading();
    return uid;
  }




}