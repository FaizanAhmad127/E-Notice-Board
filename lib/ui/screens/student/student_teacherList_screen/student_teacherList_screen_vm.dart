import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class StudentTeacherListScreenVM extends ChangeNotifier
{
    final TextEditingController _searchController=TextEditingController();
    final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
    List<UserSignupModel> _listOfTeachers=[];
    List<UserSignupModel> _searchList=[];
    final Logger _logger=Logger();



  StudentTeacherListScreenVM()
    {
      getListOfTeachers();
      _searchController.addListener(() {
        searchTeachers(_searchController.text);
      });
    }


    Future getListOfTeachers()async
    {
      try{
        await _userProfileService.getAllTeachers().then((listOfTeachers) {
              setListOfTeachers=listOfTeachers;
              setSearchList=listOfTeachers;
        });
      }
      catch(error){
        _logger.e("error at getListOfTeachers/studentteacherlistvm.dart $error");
      }

    }

    TextEditingController get searchController=>_searchController;
    List<UserSignupModel> get listOfTeachers => _listOfTeachers;
    List<UserSignupModel> get getSearchList => _searchList;

    void searchTeachers(String searchText)
    {
      setSearchList=searchText.isNotEmpty?
      List<UserSignupModel>.from(listOfTeachers.where((element) => element.fullName!.toLowerCase().contains(searchText.toLowerCase())))
          :listOfTeachers;
    }
    set setSearchList(List<UserSignupModel> ideas)
    {
      _searchList=ideas;
      notifyListeners();
    }

    set setListOfTeachers(List<UserSignupModel> list)
    {
       _listOfTeachers=list;
       notifyListeners();
    }

    @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}