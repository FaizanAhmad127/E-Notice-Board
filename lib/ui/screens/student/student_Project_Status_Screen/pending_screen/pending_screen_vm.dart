import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/enums/enums.dart';
import '../../../../../core/models/idea/idea_model.dart';

class PendingScreenVM extends ChangeNotifier
{
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  final Logger _logger=Logger();
  List<IdeaModel> _ideasList=[];
  List<IdeaModel> _searchList=[];
  final TextEditingController _searchController=TextEditingController();
  bool isFirstTime=true;


  PendingScreenVM()
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
      _firebaseFirestore.collection("post")
          .snapshots().listen((querySnap) {
            _ideasList=[];
        for (var docSnap in querySnap.docs) {
          ideaModel=IdeaModel.fromJson(docSnap);
          if(ideaModel.status=='accepted')
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
      });
    }
    catch(error)
    {
      _logger.e("error at listOfIdeas /PendingScreenVM.dart $error");

    }
  }

  void searchIdeas(String searchText)
  {
    setSearchList=searchText.isNotEmpty?
    List<IdeaModel>.from(_ideasList.where((element) => element.ideaTitle.toLowerCase().contains(searchText.toLowerCase())))
        :_ideasList;
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
    _searchController.dispose();
  }
}