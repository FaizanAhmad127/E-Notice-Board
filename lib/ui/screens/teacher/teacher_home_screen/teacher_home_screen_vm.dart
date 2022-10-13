import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class TeacherHomeScreenVM extends ChangeNotifier{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final Logger _logger=Logger();
  List<IdeaModel> _ideasList=[];
  List<IdeaModel> _searchList=[];
  final TextEditingController _searchController=TextEditingController();
  bool isFirstTime=true;
  late StreamSubscription postStreamSubscription;
  late StreamSubscription userStreamSubscription;
  bool isDispose=false;
  String uid="";
  TextEditingController get searchController=>_searchController;



  TeacherHomeScreenVM()
  {
    uid=_firebaseAuth.currentUser!.uid;
    listOfIdeas();
    _searchController.addListener(() {
      searchIdeas(_searchController.text);
    });
  }
  Future listOfIdeas()async
  {
    List<String> listOfIdeas=[];
    IdeaModel ideaModel;
      try {
        await _userProfileService.getProfileDocument(uid, "teacher").then((userSignupModel) {
          listOfIdeas=userSignupModel?.ideaList??[];
        }).then((value) {
          if(listOfIdeas.isNotEmpty)
            {
              postStreamSubscription=_firebaseFirestore.collection("post")
                  .orderBy('timeStamp',descending: true)
                  .snapshots().listen((querySnap) {
                if(isDispose==false)
                {
                  _ideasList=[];
                  for (var docSnap in querySnap.docs) {
                    ideaModel=IdeaModel.fromJson(docSnap);
                    if(listOfIdeas.contains(ideaModel.ideaId))
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
        });


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