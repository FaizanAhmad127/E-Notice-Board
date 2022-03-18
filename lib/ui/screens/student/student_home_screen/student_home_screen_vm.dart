import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';

class StudentHomeScreenVM extends ChangeNotifier{
  FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final Logger _logger=Logger();
  bool _isAvailable=true;
  List<IdeaModel> _ideasList=[];
  List<IdeaModel> _searchList=[];
  final TextEditingController _searchController=TextEditingController();
  bool isFirstTime=true;
  late StreamSubscription streamSubscription;
  bool isDispose=false;



  StudentHomeScreenVM()
  {
    isUserAvailable();
    listOfIdeas();
    _searchController.addListener(() {
      searchIdeas(_searchController.text);
    });
  }

  Future isUserAvailable()async
  {
    try
    {

        DocumentReference<Map<String,dynamic>> documentRef= _firebaseFirestore.collection("student")
          .doc(_firebaseAuth.currentUser!.uid);
       documentRef.snapshots().listen((docSnap) {
        UserSignupModel.fromJson(docSnap).available=="no"?
        setIsAvailable=false:setIsAvailable=true;
      });

    }
    catch(error)
    {
      _logger.e("error at isUserAvailable /StudentHomeScreenVM.dart $error");

    }
  }
  Future listOfIdeas()async
  {
    IdeaModel ideaModel;
      try {
        streamSubscription=_firebaseFirestore.collection("post")
            .snapshots().listen((querySnap) {
              if(isDispose==false)
                {
                  _ideasList=[];
                  for (var docSnap in querySnap.docs) {
                    ideaModel=IdeaModel.fromJson(docSnap);
                    if(ideaModel.status!='finished')
                    {
                      _ideasList.add(ideaModel);
                    }

                  }
                  setIdeasList = _ideasList;
                  if(isFirstTime==true) // to load the listview with all ideas
                    {
                      setSearchList=_ideasList;
                      isFirstTime=false;
                    }

                }
              else
                {
                  streamSubscription.cancel();
                }
                }
        );

      }
      catch(error)
      {
        _logger.e("error at listOfIdeas /StudentHomeScreenVM.dart $error");

      }
  }


  void searchIdeas(String searchText)
  {
    try
    {
      setSearchList=searchText.isNotEmpty?
      List<IdeaModel>.from(_ideasList.where((element) => element.ideaTitle.toLowerCase().contains(searchText.toLowerCase())))
          :_ideasList;
    }
    catch(error)
    {
      _logger.e("error at searchIdea/StudentHomeScreenVM.dart $error");
    }

  }




  bool get isAvailable=>_isAvailable;
  List<IdeaModel> get getIdeasList=>_ideasList;
  List<IdeaModel> get getSearchList=>_searchList;
  TextEditingController get searchController=>_searchController;

  set setIsAvailable(bool a)
  {
    _isAvailable=a;
    notifyListeners();
  }

  set setIdeasList(List<IdeaModel> ideas)
  {
    _ideasList=ideas;
    notifyListeners();
  }
  set setSearchList(List<IdeaModel> ideas)
  {
    _searchList=ideas;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
    _searchController.dispose();

  }
}