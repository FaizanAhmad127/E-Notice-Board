import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';

class UserProfileService{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;
  final Logger _logger=Logger();


  Future createProfileDocument({required String userType,required String uid,required UserSignupModel userSignupModel})async
  {
    BotToast.showLoading();

    try
    {
      await _firebaseFirestore.collection(userType).
      doc(uid).
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
    return signupModel;


  }

  Future<List<UserSignupModel>> getAllTeachers()async
  {
    List<UserSignupModel> teachersList=[];
    try
    {
     await _firebaseFirestore.collection("teacher").get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          try
          {
            teachersList.add(UserSignupModel.fromJson(doc.doc));
          }
          catch(error)
       {
         _logger.e("error at getAllTeachers/UserProfileService.dart $error");
       }

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
          try
          {
            studentList.add(UserSignupModel.fromJson(doc.doc));
          }
          catch(error)
        {
          _logger.e("error at getAllStudents/UserProfileService.dart $error");
        }

        }});

    }
    catch(error)
    {
      _logger.e("error at getAllStudents/UserProfileService.dart $error");
    }
    return studentList;
  }

  Future postOnlineStatus(String userType,String uid,String status)async
  {
    //print('$userType is $status now');
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

  Future<String> uploadProfileImage(String userType, String uid,File file)async
  {
    String downloadURL="";
    BotToast.showLoading();
    try
    {
      await _firebaseStorage.ref().child("$userType/$uid/profilePicture").putFile(file)
          .then((snapshot)async{
            downloadURL=await snapshot.ref.getDownloadURL();
            //print("download url is $downloadURL");
         _firebaseFirestore.collection(userType).doc(uid).
         set({
           'profilePicture':await snapshot.ref.getDownloadURL(),
         },SetOptions(merge: true));
      }).then((value){
        BotToast.showText(text: "Profile Picture Uploaded");
      });
    }
    catch(error)
    {
      _logger.e("error at uploadProfileImage/UserProfileService.dart $error");
    }

    BotToast.closeAllLoading();
    return downloadURL;
  }

  Future updateNameAndOccupation(String userType, String uid,String name,String occupation)async
  {
    try{
      await _firebaseFirestore.collection(userType).doc(uid).
    set({
        'fullName':name,
        'occupation':occupation,
      },SetOptions(merge: true));
    }
    catch(error)
    {
      _logger.e("error at updateNameAndOccupation/UserProfileService.dart $error");
    }
  }
  
  Future<List<UserSignupModel>> getAvailableStudents(String uid)async
  {
    BotToast.showLoading();
    List<UserSignupModel> listOfStudents=[];
    try{
      await _firebaseFirestore.collection("student").
      where('available',isEqualTo: "yes").get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          if(doc.doc.id!=uid)
            {
              listOfStudents.add(UserSignupModel.fromJson(doc.doc));
            }

        }});
    }
    catch(error)
    {
      _logger.e("error at getAvailableStudents/UserProfileService.dart $error");
    }
    BotToast.closeAllLoading();
    return listOfStudents;
  }
  Future<List<UserSignupModel>> getAvailableTeachers(String uid)async
  {
    BotToast.showLoading();
    List<UserSignupModel> listOfTeachers=[];
    try{
      await _firebaseFirestore.collection("teacher").
      where('available',isEqualTo: "yes").get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          if(doc.doc.id!=uid)
          {
            listOfTeachers.add(UserSignupModel.fromJson(doc.doc));
          }
        }});
    }
    catch(error)
    {
      _logger.e("error at getAvailableTeachers/UserProfileService.dart $error");
    }
    BotToast.closeAllLoading();
    return listOfTeachers;
  }

  Future deleteStudent(String studentUid)async
  {
 
    print('student uid is: $studentUid');

    try
    {
      ///delete student result
      await _firebaseFirestore.collection('result').doc('2021-2022').collection('marks').doc(studentUid).delete();

      /// deleting the user from post/idea , if the student is single in an idea and no more teammates then delete the whole idea

      await _firebaseFirestore.collection('post').where('students',arrayContains: studentUid).get().then((querySnap) async{
        await Future.forEach(querySnap.docs, (QueryDocumentSnapshot queryDoc) async{
          IdeaModel idea= IdeaModel.fromJson(queryDoc);
          if(idea.students.length==1)
          {
            print('whole post will be removed: post id: ${idea.ideaId}');
            await queryDoc.reference.delete();
          }
          else
          {
            List<String> tempList=idea.students;
            print('temlist length at post is before ${tempList.length}');
            tempList.remove(studentUid);
            print('temlist length at post is after ${tempList.length}');
            await queryDoc.reference.update({'students':tempList});
          }

        });
      });

      ///now delete the student
      await _firebaseFirestore.collection('student').doc(studentUid).delete();

    }
    catch(error)
    {
      _logger.e("error at deleteStudent/UserProfileService.dart $error");
    }

    
    
  }

}