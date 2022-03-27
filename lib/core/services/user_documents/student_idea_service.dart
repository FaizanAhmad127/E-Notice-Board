import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/idea/file_model.dart';
import 'package:notice_board/core/models/idea/idea_model.dart';
import 'package:notice_board/core/models/notification/teacher_notification_model.dart';
import 'package:notice_board/core/services/user_documents/teacher_notification_service.dart';


class StudentIdeaService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;

  Future postIdea(String title, String desc, String ownerUID,List<String> studentsUid,
                 List<String> teachersUid, String ideaType, List<PlatformFile> filesList, int ideaId) async
  {
    BotToast.showLoading();
    try {
      studentsUid.add(ownerUID);

      List<FileModel> fileModelList=[];
      /// Adding files to firebase Storage
       await Future.forEach(filesList, (PlatformFile platformFile) async{

          File file=File(platformFile.path??"");
          await _firebaseStorage.ref().child("post/$ideaId/files/${platformFile.name}")
              .putFile(file).then((uploadTask) async {
            String downloadUrl = await uploadTask.ref.getDownloadURL();
            fileModelList.add(
              FileModel(platformFile.name, platformFile.extension??"", downloadUrl, platformFile.size)
            );
          });

        }).then((value) async{
         /// Adding idea to firestore post collection
         IdeaModel ideaModel=IdeaModel(ideaId.toString(), ideaType, title,
             desc, ownerUID, teachersUid.length, studentsUid,
             teachersUid, fileModelList, ideaId);

         await _firebaseFirestore.collection("post").doc(ideaId.toString()).
         set(ideaModel.toJson(), SetOptions(merge: true,
         )).then((value) async{

           ///adding idea id to selected Students
           //current student is also a team member so add him/her
           await addIdeaIdToStudent(ideaId.toString(), studentsUid)
               .then((value) async{

             /// adding idea id to teacher notification
             await TeacherNotificationService().setTeacherNotification(
                 teachersUid,
                 TeacherNotificationModel("permission", ideaId.toString(),
                     title, ideaType)).then((value) {

               BotToast.showText(text: "Idea Submitted");
             });

           });



         });

       });

    }
    catch (error) {
      BotToast.showText(text: "Unable to submit, try again!");
      _logger.e("error at postIdea services/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future addIdeaIdToStudent(String ideaId, List<String> studentsUids) async
  {
    BotToast.showLoading();
    try {
      //first fetch the existing list of ideas
      await Future.forEach(studentsUids, (String uid) async{
        await _firebaseFirestore.collection("student").doc(uid).get().
        then((docSnap) {
          //now append the list with new idea id
          List<String> ideaList = List<String>.from(docSnap.get('ideaList'));
          ideaList.add(ideaId);
          _firebaseFirestore.collection("student").doc(uid).set({
            'available': "no",
            'ideaList': ideaList
          }, SetOptions(merge: true));
        });
      });

    }

    catch (error) {
      _logger.e(
          "error at addIdeaIdToStudent services/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }


  Future addIdeaIdToTeacher(String ideaId, String uid) async
  {
    BotToast.showLoading();
    try {
      //first fetch the existing list of ideas
      await _firebaseFirestore.collection("teacher").doc(uid).get().
      then((docSnap) {
        //now append the list with new idea id
        List<String> ideaList = List<String>.from(docSnap.get('ideaList'));
        ideaList.add(ideaId);
        _firebaseFirestore.collection("teacher").doc(uid).set({
          'ideaList': ideaList
        }, SetOptions(merge: true));
      });
    }
    catch (error) {
      _logger.e(
          "error at addIdeaIdToTeacher services/StudentIdeaService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  Future<List<IdeaModel>> getAllUserIdeas(String uid) async
  {
    List<IdeaModel> ideasList = [];
    try {
      await _firebaseFirestore.collection("post")
          .where('students', arrayContains: uid).
      orderBy('timeStamp', descending: true).get().then((docsSnap) {
        for (var doc in docsSnap.docChanges) {
          ideasList.add(IdeaModel.fromJson(doc.doc));
        }
      });
    }
    catch (error) {
      _logger.e(
          "error at getAllUserIdeas services/StudentIdeaService.dart $error");
    }
    return ideasList;
  }
  Future<IdeaModel?> getIdea(String ideaId)async
  {
       IdeaModel? ideaModel;
       try {
         await _firebaseFirestore.collection("post").doc(ideaId).get().then((docSnap){
           ideaModel=IdeaModel.fromJson(docSnap);
         });
       }
       catch (error) {
         _logger.e(
             "error at getAllUserIdeas getIdea/StudentIdeaService.dart $error");
       }
      return ideaModel;
  }


}
