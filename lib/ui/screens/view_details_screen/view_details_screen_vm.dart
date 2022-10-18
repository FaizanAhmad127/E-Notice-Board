import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/file_model.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/file_management/file_download_open_service.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/user_documents/student_idea_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../core/services/chat/chat_service.dart';

class ViewDetailsScreenVM extends ChangeNotifier{

  String ideaId;
  final StudentIdeaService _studentIdeaService=GetIt.I.get<StudentIdeaService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FileDownloadOpenService _fileDownloadOpenService=GetIt.I.get<FileDownloadOpenService>();
  IdeaModel? _ideaModel;
  final ChatService _chatService=GetIt.I.get<ChatService>();
  UserSignupModel? _userSignupModel;
  List<UserSignupModel> _listOfStudents=[];
  List<UserSignupModel> listOfTeachers=[];
  List<FileModel> _listOfFiles=[];

  final Logger _logger=Logger();
  ViewDetailsScreenVM(this.ideaId)
  {
      getIdea();
      getAllTeacher();

  }

  Future getIdea()async
  {
    try
    {
      await _studentIdeaService.getIdea(ideaId).then((ideaM) {
        setIdeaModel=ideaM!;
        if(ideaM.acceptedBy.isNotEmpty)
          {
            _userProfileService.getProfileDocument(ideaM.acceptedBy, "teacher").then((userDoc) {
              setUserSignupModel=userDoc!;
            });
          }
        if(ideaM.students.isNotEmpty)
          {
            for (var uid in ideaM.students) {
              _userProfileService.getProfileDocument(uid, "student").then((student) {
                setListOfStudents=student!;
              });
            }
          }
        if(ideaM.filesList.isNotEmpty)
          {
            for (var fileMap in ideaM.filesList) {
              setListOfFiles=fileMap;
            }

          }


      });
    }
    catch(error)
    {
      _logger.e("error at getIdea/ view details screen vm $error");
    }

  }

  Future downloadFile(String url)async
  {
    try
    {
      await _fileDownloadOpenService.downloadFile(url);
    }
    catch(error)
    {
      _logger.e("error at downloadFile/ view details screen vm $error");
    }

  }

  Future setTitle(String title)async
  {
    await _studentIdeaService.editIdeaTitle(title, ideaId);
    await getIdea();
  }

  Future getAllTeacher()async
  {
    listOfTeachers=await _userProfileService.getAllTeachers();
  }
  Future changeSupervisor(String newSupervisorId)async
  {
    await _studentIdeaService.changeSupervisor(ideaId, newSupervisorId);
    await _studentIdeaService.removeIdeaIdFromTeacher(ideaId, userSignupModel?.uid??'');
    await _studentIdeaService.addIdeaIdToTeacher(ideaId, newSupervisorId);

    List<String> studentUids=listOfStudents.map((e) => e.uid??'').toList();
    await Future.forEach(studentUids, (stdUid) async{

      bool isChatExist=await _chatService.isChatAlreadyExist(stdUid.toString(),newSupervisorId);
      if(!isChatExist)
      {
        await _chatService.setChatDocument(newSupervisorId,
            stdUid.toString(), "teacher", "student");
      }


    });
    resetListOfFiles();
    resetListOfStudent();
    await getIdea();
  }

  Future deleteIdea()async
  {
    await _studentIdeaService.deleteIdea(ideaId, _listOfStudents.map((e) => e.uid??'').toList());
  }

  IdeaModel? get ideaModel=>_ideaModel;
  UserSignupModel? get userSignupModel=>_userSignupModel;
  List<UserSignupModel> get listOfStudents=>_listOfStudents;
  List<FileModel> get listOfFiles=>_listOfFiles;

  set setIdeaModel(IdeaModel idea)
  {
    _ideaModel=idea;
    notifyListeners();
  }
  set setUserSignupModel(UserSignupModel user)
  {
    _userSignupModel=user;
    notifyListeners();
  }
  void resetListOfStudent()
  {
    _listOfStudents.clear();
  }
  void resetListOfFiles()
  {
    _listOfFiles.clear();
  }
  set setListOfStudents(UserSignupModel students)
  {
    _listOfStudents.add(students);
    notifyListeners();
  }
  set setListOfFiles(FileModel file)
  {
    _listOfFiles.add(file);
    notifyListeners();
  }
}