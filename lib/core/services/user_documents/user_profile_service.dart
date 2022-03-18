import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';

class UserProfileService{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final Logger _logger=Logger();

  Future createProfileDocument({required String userType,required UserSignupModel userSignupModel})async
  {
    BotToast.showLoading();
    try
    {
      await _firebaseFirestore.collection(userType).
      doc(_firebaseAuth.currentUser!.uid).
      set(userSignupModel.toJson(),SetOptions(
        merge: true,
      ));
    }
    catch(error)
    {
      _logger.e("error at createProfileDocument services/UserProfileService.dart $error");
    }
    BotToast.closeAllLoading();

  }
  Future<UserSignupModel?> getProfileDocument(String uid,String userType)async
  {
    BotToast.showLoading();
    UserSignupModel? signupModel;
    try
    {
      DocumentSnapshot<Map<String,dynamic>> _documentReference=await _firebaseFirestore.collection(userType).doc(uid).get();
      signupModel= UserSignupModel.fromJson(_documentReference);
    }
    catch(error)
    {
      _logger.e("error at getProfileDocument/UserProfileService.dart $error");
    }
    BotToast.closeAllLoading();
    return signupModel;


  }
  Future<List<UserSignupModel>> getAllTeachers()async
  {
    List<UserSignupModel> teachersList=[];
    try
    {
     await _firebaseFirestore.collection("teacher").get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          teachersList.add(UserSignupModel.fromJson(doc.doc));
        }});

    }
    catch(error)
    {
      _logger.e("error at getAllTeachers/UserProfileService.dart $error");
    }
    return teachersList;
  }
  Future<List<UserSignupModel>> getAllStudents()async
  {
    List<UserSignupModel> studentList=[];
    try
    {
      await _firebaseFirestore.collection("student").get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          studentList.add(UserSignupModel.fromJson(doc.doc));
        }});

    }
    catch(error)
    {
      _logger.e("error at getAllTeachers/UserProfileService.dart $error");
    }
    return studentList;
  }

  Future postOnlineStatus(String userType,String uid,String status)async
  {
    try{
      await _firebaseFirestore.collection(userType).doc(uid).
      set({
        'onlineStatus':status,
      },SetOptions(merge: true));
    }
    catch(error)
    {
      _logger.e("error at postOnlineStatus/UserProfileService.dart $error");
    }

  }
}