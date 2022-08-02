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

  Future userSignOut()async
  {
    BotToast.showLoading();
    try{
      await _firebaseAuth.signOut();
    }
    catch(error)
    {
      _logger.e("Error at userSignOut method, services/UserAuthService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  String isUserLoggedIn()
  {
    String uid;
    try{
      uid=_firebaseAuth.currentUser!.uid;
    }
    catch(e)
    {
      uid="";
    }
    return uid;

  }

  Future forgotPassword(String email)async{

    try
    {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        BotToast.showText(text: 'Password reset email is sent, Please check your email',
            duration: Duration(seconds: 3));
      });
    }
    catch(error)
    {
      BotToast.showText(text: 'Error! $error',duration: Duration(seconds: 3));
    }



  }




}