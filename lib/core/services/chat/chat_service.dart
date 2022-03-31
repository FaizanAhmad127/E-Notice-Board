import 'dart:async';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/chat/chat_model.dart';
import 'package:notice_board/core/models/chat/message_model.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import '../../models/idea/file_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  Future setChatDocument(int timeStamp,String user1Uid,String user2Uid,
      String user1Occupation,String user2Occupation) async {

     String chatId=timeStamp.toString();
    try
    {
      ChatModel chatModel=ChatModel(chatId, timeStamp, user1Uid, user2Uid, user1Occupation, user2Occupation);
      await _firestore.collection("chat").doc(chatId).
      set(chatModel.toJson(),SetOptions(merge: true));

      ///adding chatIds to respective users(student,teacher)

      ///Getting previous chat ids of user1

      for(int i=1;i<=2;i++)
        {
          List<String> chatList=[];

          await _firestore.collection(i==1?user1Occupation:user2Occupation).doc(i==1?user1Uid:user2Uid).get().then((docSnap){
            chatList=UserSignupModel.fromJson(docSnap).chatList;
          }).then((value)async{
            chatList.add(chatId);
            ///appending chat ids to user
            await _firestore.collection(i==1?user1Occupation:user2Occupation).doc(i==1?user1Uid:user2Uid)
                .set(
                {
                  'chatList':chatList
                },
                SetOptions(merge: true));
          });
        }

    }
    catch (error) {
    _logger.e("error at setChatDocument/ ChatService.dart $error");
    }
  }
  Future setMessageDocument(String chatId,String text, String sentBy, int timeStamp, PlatformFile? platformFile)async
  {
    String messageId=timeStamp.toString();
    FileModel? fileModel;
    try{
      if(platformFile!=null)
        {
          BotToast.showLoading();
          File file=File(platformFile.path??"");
          await _storage.ref().child("chat/$chatId/$messageId/${platformFile.name}")
              .putFile(file).then((uploadTask) async {
            String downloadUrl = await uploadTask.ref.getDownloadURL();

            fileModel=FileModel(platformFile.name, platformFile.extension??"", downloadUrl, platformFile.size);

          });
        }
      MessageModel messageModel=MessageModel(text, sentBy, timeStamp, fileModel);
      await _firestore.collection("chat").doc(chatId).collection("messages").doc(messageId).
      set(

          messageModel.toJson(),
          SetOptions(merge: true));

    }
    catch (error) {
      _logger.e("error at setMessageDocument/ ChatService.dart $error");
    }
    BotToast.closeAllLoading();
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> getChatDocument(
      String chatId) {
    late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
        streamSubscription;
    try {
      streamSubscription = _firestore
          .collection("chat")
          .doc(chatId)
          .snapshots()
          .listen((event) {});
    } catch (error) {
      _logger.e("error at getChatDocument/ ChatService.dart $error");
    }
    return streamSubscription;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getMessagesCollection(
      String chatId) {
    late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
        streamSubscription;
    try {
      streamSubscription = _firestore
          .collection("chat")
          .doc(chatId)
          .collection("messages").orderBy('timeStamp',descending: false)
          .snapshots()
          .listen((event) {});
    } catch (error) {
      _logger.e("error at getMessagesCollection/ ChatService.dart $error");
    }
    return streamSubscription;
  }

  Future setRecentTextTimeAndUnreadCount(String chatId,String recentText,int timeStamp,String user1or2)async
  {
     String userUnreadCount=user1or2=="user1"?"user2UnreadCount"
        :"user1UnreadCount";
     int unreadCount=0;
    try
        {
          await _firestore.collection('chat').doc(chatId).get().then((docSnap){
            ChatModel chatModel=ChatModel.fromJson(docSnap);
            unreadCount=(user1or2=="user1"?chatModel.user2UnReadCount
                    :chatModel.user1UnReadCount);
            if((user1or2=="user1"?chatModel.isUser2Read:chatModel.isUser1Read)=="no")
            {
              unreadCount++;
            }


          }).then((value)async{
            await _firestore.collection("chat").doc(chatId).
            set(
                {
                  'recentText':recentText,
                  'recentTextTime':timeStamp,
                  userUnreadCount:unreadCount,
                },
                SetOptions(merge: true));
          });

        }

  catch (error) {
  _logger.e("error at setRecentTextTime/ ChatService.dart $error");
  }
  }
  Future setIsUserRead(String chatId, String user1or2,String yesNo)async
  {


    try{
      if(yesNo=="no")
        {
          await _firestore.collection("chat").doc(chatId)
              .set(
              {
                user1or2=="user1"?'isUser1Read':'isUser2Read':yesNo,


              },
              SetOptions(merge: true));
        }
      else
        {
          await _firestore.collection("chat").doc(chatId)
              .set(
              {
                user1or2=="user1"?'isUser1Read':'isUser2Read':yesNo,
                user1or2=="user1"?'user1UnreadCount':'user2UnreadCount':0,
              },
              SetOptions(merge: true));
        }


    }
    catch (error) {
      _logger.e("error at setIsUserRead/ ChatService.dart $error");
    }
  }

}
