import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/notification/student_idea_status_model.dart';
import 'package:notice_board/core/services/notification/student_idea_status_service.dart';

class StudentNotificationScreenVM extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  List<StudentIdeaStatusModel> _ideasList=[];
  final Logger _logger = Logger();
  late String uid;
  bool isDispose=false;

  StudentNotificationScreenVM()
  {
    uid=firebaseAuth.currentUser!.uid;
    getIdeaStatusNotification();

  }

  void getIdeaStatusNotification()
  {
    try
    {
      firestore.collection("student").doc(uid).collection("ideaStatusNotification").
      orderBy('timeStamp',descending: false).snapshots().listen((docsSnapshot) {
        if(isDispose==false)
          {
            for (var doc in docsSnapshot.docChanges) {
              setIdeasList=StudentIdeaStatusModel.fromJson(doc.doc);
            }
          }



      });
    }
    catch(error)
    {
      _logger.e("error at getIdeaStatusNotification/StudentNotificationScreenVM $error");
    }
  }

  List<StudentIdeaStatusModel> get getIdeasList=>_ideasList;

  set setIdeasList(StudentIdeaStatusModel idea)
  {

    _ideasList.insert(0, idea);
    notifyListeners();
  }
 @override
  void dispose() {

    super.dispose();
    isDispose=true;
  }
}