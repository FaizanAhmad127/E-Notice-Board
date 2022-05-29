import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';

class StudentProfileScreenVm extends ChangeNotifier{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();
  List<IdeaModel> _ideasList=[];
  bool isFirstTime=true;
  late StreamSubscription postStreamSubscription;
  bool isDispose=false;
  late UserSignupModel thisUser;
  StudentProfileScreenVm(UserSignupModel user){
    thisUser=user;
    listOfIdeas();
  }


  Future listOfIdeas()async
  {
    IdeaModel ideaModel;
    try {
      postStreamSubscription=_firebaseFirestore.collection("post")
          .orderBy('timeStamp',descending: true)
      .where('students',arrayContains: thisUser.uid)
          .snapshots().listen((querySnap) {
        if(isDispose==false)
        {
          _ideasList=[];
          for (var docSnap in querySnap.docs) {
            ideaModel=IdeaModel.fromJson(docSnap);
              _ideasList.add(ideaModel);

          }
          setIdeasList = _ideasList;


        }
        else
        {
          postStreamSubscription.cancel();

        }
      }
      );

    }
    catch(error)
    {
      _logger.e("error at listOfIdeas /StudentHomeScreenVM.dart $error");

    }
  }

  List<IdeaModel> get getIdeasList=>_ideasList;

  set setIdeasList(List<IdeaModel> ideas)
  {
    _ideasList=ideas;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
    postStreamSubscription.cancel();
  }

}