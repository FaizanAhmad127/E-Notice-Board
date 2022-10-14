import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

class CoordinatorStudentListScreenVM extends ChangeNotifier
{
  final TextEditingController _searchController=TextEditingController();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  List<UserSignupModel> _listOfStudents=[];
  List<UserSignupModel> _searchList=[];
  final Logger _logger=Logger();
  bool isDispose=false;



  CoordinatorStudentListScreenVM()
  {
    getListOfStudents();
    _searchController.addListener(() {
      searchStudents(_searchController.text);
    });
  }


  Future getListOfStudents()async
  {
    try{
      await _userProfileService.getAllStudents().then((listOfStudents) {
        if(isDispose==false)
          {
            setListOfStudents=listOfStudents;
            setSearchList=listOfStudents;
          }

      });
    }
    catch(error){
      _logger.e("error at getListOfTeachers/coordinatorstudentlistvm.dart $error");
    }

  }

  TextEditingController get searchController=>_searchController;
  List<UserSignupModel> get listOfStudents => _listOfStudents;
  List<UserSignupModel> get getSearchList => _searchList;

  void searchStudents(String searchText)
  {
    setSearchList=searchText.isNotEmpty?
    List<UserSignupModel>.from(listOfStudents.where((element) => element.fullName!.toLowerCase().contains(searchText.toLowerCase())))
        :listOfStudents;
  }
  set setSearchList(List<UserSignupModel> userList)
  {
    _searchList=userList;
    notifyListeners();
  }

  set setListOfStudents(List<UserSignupModel> list)
  {
    _listOfStudents=list;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
    _searchController.dispose();
  }
}