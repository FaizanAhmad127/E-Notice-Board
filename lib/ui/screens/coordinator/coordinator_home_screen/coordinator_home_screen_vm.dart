import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';

import '../../../../core/models/user_authentication/user_signup_model.dart';

class CoordinatorHomeScreenVM extends ChangeNotifier{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  //FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final Logger _logger=Logger();
  List<IdeaModel> _ideasList=[];
  List<IdeaModel> _searchList=[];
  final TextEditingController _searchController=TextEditingController();
  bool isFirstTime=true;
  late StreamSubscription postStreamSubscription;
  //late StreamSubscription userStreamSubscription;
  bool isDispose=false;



  CoordinatorHomeScreenVM()
  {

    listOfIdeas();
    _searchController.addListener(() {
      searchIdeas(_searchController.text);
    });
  }

  Future listOfIdeas()async
  {
    IdeaModel ideaModel;
    try {
      postStreamSubscription=_firebaseFirestore.collection("post")
          .orderBy('timeStamp',descending: true)
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





  List<IdeaModel> get getIdeasList=>_ideasList;
  List<IdeaModel> get getSearchList=>_searchList;
  TextEditingController get searchController=>_searchController;


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
    postStreamSubscription.cancel();



  }
}