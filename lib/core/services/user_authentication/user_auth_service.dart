import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  late UserCredential? _userCredential;
  final _logger=Logger();

  Future<String> userLogin(String _email, String _password)async
  {
    BotToast.showLoading();
    try
    {
      _userCredential=await _firebaseAuth.signInWithEmailAndPassword(email: _email, password: _password);
    }
    catch(error)
    {
      _logger.e("Error at userLogin method, services/UserAuthService.dart");
    }
    BotToast.closeAllLoading();
    return _userCredential!.user!.uid;
  }
  Future<String> userSignup(String _email, String _password)async
  {
    BotToast.showLoading();
    try
    {
      _userCredential=await _firebaseAuth.createUserWithEmailAndPassword(email: _email, password: _password);
    }
    catch(error)
    {
      _logger.e("Error at userLogin method, services/UserAuthService.dart");
    }
    BotToast.closeAllLoading();
    return _userCredential!.user!.uid;
  }




}