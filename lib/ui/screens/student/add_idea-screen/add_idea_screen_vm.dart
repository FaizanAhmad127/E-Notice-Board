
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/file_management/file_picker_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/teacher_notification_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';
import 'package:notice_board/core/services/validate_service.dart';

import '../../../../core/services/navigation_service.dart';
import '../student_home_screen/student_home_screen.dart';
import '../student_root_screen/student_root_screen/student_root_screen.dart';

class AddIdeaScreenVM extends ChangeNotifier
{
  final StudentIdeaService _studentIdeaService =GetIt.I.get<StudentIdeaService>();
  final TeacherNotificationService _teacherNotificationService=GetIt.I.get<TeacherNotificationService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final Validate _validate=Validate();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FilePickerService _filePickerService=FilePickerService();
  List<String> _selectedStudentsList=[];
  List<String> _selectedTeachersList=[];
  List<UserSignupModel> _listOfStudents=[];
  List<UserSignupModel> _listOfTeachers=[];
  List<PlatformFile> _pickedFilesList=[];
  final Logger _logger=Logger();
  int _groupValue=0;
  String _titleValue="";
  String _descriptionValue="";
  String uid="";

  AddIdeaScreenVM()
  {
    uid=_firebaseAuth.currentUser!.uid;
    getStudents();
    getTeachers();
  }

  Future post(BuildContext context)async
  {
    try
    {
      int dateTime=(DateTime.now().millisecondsSinceEpoch);
      if(_validate.validateIdea(titleValue, descriptionValue,
          selectedStudentsList.length, selectedTeachersList.length,
          pickedFilesList.length)==true)
        {
          await _studentIdeaService.postIdea(titleValue, descriptionValue, uid,
              selectedStudentsList, selectedTeachersList,
              groupValue==0?"Project":"Research", pickedFilesList, dateTime).then((value) {
            NavigationService().navigatePushReplacement(context,  StudentRootScreen());
          });

        }


    }
    catch(error)
    {
      _logger.e("error at post/add_idea_screen_vm.dart $error");
    }

  }

  Future getStudents()async
  {
    await _userProfileService.getAvailableStudents(uid).then((students) {
      setListOfStudents=students;
    });
  }
  Future getTeachers()async
  {
    await _userProfileService.getAvailableTeachers(uid).then((teachers) {
      setListOfTeachers=teachers;
    });
  }

  Future pickFiles()async{
    try
    {
      await _filePickerService.multipleFilePicker().then((listOfPickedFiles){
        setPickedFileList=listOfPickedFiles;


      });

    }
    catch(error)
    {
      _logger.e("error at pickFiles/add_idea_screen_vm.dart $error");
    }


  }

  List<UserSignupModel> get listOfStudents=>_listOfStudents;
  List<UserSignupModel> get listOfTeachers=>_listOfTeachers;
  List<String> get selectedStudentsList=>_selectedStudentsList;
  List<String> get selectedTeachersList=>_selectedTeachersList;
  int get groupValue=>_groupValue;
  String get titleValue=>_titleValue;
  String get descriptionValue=>_descriptionValue;
  List<PlatformFile> get pickedFilesList=>_pickedFilesList;

  set setListOfStudents(List<UserSignupModel> students)
  {
    _listOfStudents=students;
    notifyListeners();
  }
  set setListOfTeachers(List<UserSignupModel> teachers)
  {
    _listOfTeachers=teachers;
    notifyListeners();
  }
  set setSelectedStudentsList(List<String> students)
  {
    _selectedStudentsList=students;
    notifyListeners();
  }
  set setSelectedTeachersList(List<String> teachers)
  {
    _selectedTeachersList=teachers;
    notifyListeners();
  }
  set setGroupValue(int a)
  {
    _groupValue=a;
    notifyListeners();
  }
  set setTitleValue(String title)
  {
    _titleValue=title;
    notifyListeners();
  }
  set setDescriptionValue(String des)
  {
    _descriptionValue=des;
    notifyListeners();
  }

  set setPickedFileList(List<PlatformFile> filesList)
  {
    for (var file in filesList) {
      _pickedFilesList.add(file);
    }
    notifyListeners();
  }


}