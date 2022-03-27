import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/file_management/file_picker_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../core/models/chat/chat_model.dart';
import '../../../core/models/chat/message_model.dart';
import '../../../core/services/chat/chat_service.dart';

class MessagesScreenVM extends ChangeNotifier{

  final ChatService _chatService=GetIt.I.get<ChatService>();
  final UserProfileService _userProfileService=GetIt.I.get<UserProfileService>();
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  UserSignupModel? _receiverSignupModel;
  final Logger _logger=Logger();
  List<MessageModel> _listOfMessages=[];
  TextEditingController _textEditingController=TextEditingController();
  bool isDispose=false;

  ChatModel previousChatModel;
  String receiverUser;
  String thisUser;
  MessagesScreenVM(this.previousChatModel,this.receiverUser,this.thisUser)
  {
    getMessages();
    getReceiverUserDocument();
    _chatService.setIsUserRead(previousChatModel.chatId??"", thisUser, "yes");
  }


  Future sentText()async
  {
    int timeStamp=Timestamp.now().millisecondsSinceEpoch;
    String text=textEditingController.text;
    if(textEditingController.text.isEmpty)
      {
        BotToast.showText(text: "Text Field is empty!");
      }
    else
      {
        textEditingController.text="";
        await _chatService.setMessageDocument(
            previousChatModel.chatId??"",
            text,
            thisUser,
            timeStamp,
            null).then((value) async{
              await _chatService.setRecentTextTimeAndUnreadCount(
                  previousChatModel.chatId??"",
                  text, timeStamp, thisUser);
        });
      }
  }
  Future sentFile()async{
    int timeStamp=Timestamp.now().millisecondsSinceEpoch;
    await FilePickerService().singleFilePicker().then((platformFile)async{
        if(platformFile!=null)
          {
            await _chatService.setMessageDocument(
                previousChatModel.chatId??"",
                "",
                thisUser,
                timeStamp,
                platformFile).then((value) async{
              await _chatService.setRecentTextTimeAndUnreadCount(
                  previousChatModel.chatId??"",
                  platformFile.name, timeStamp, thisUser);
            });
          }

    });
  }

  Future getReceiverUserDocument()async{
    try
    {
      _firestore.collection(receiverUser=="user1"?
      previousChatModel.user1Occupation??""
          :previousChatModel.user2Occupation??"").doc(receiverUser=="user1"?
      previousChatModel.user1Uid??""
          :previousChatModel.user2Uid??"").snapshots().listen((docSnap) {
            if(isDispose==false)
              {
                setReceiverSignupModel=UserSignupModel.fromJson(docSnap);
              }

      });
    }
    catch(error)
      {
        _logger.e("error at getReceiverUserDocument / MessagesScreenVM $error");
      }

  }



  Future getMessages()async
  {
    _chatService.getMessagesCollection(previousChatModel.chatId??"").onData((docsSnap) {
      for (var doc in docsSnap.docChanges) {
        if(isDispose==false)
          {
            setListOfMessages=MessageModel.fromJson(doc.doc);
          }

      }

    });
  }

  List<MessageModel> get listOfMessages=>_listOfMessages;
  UserSignupModel? get receiverSignupModel=>_receiverSignupModel;
  TextEditingController get textEditingController=>_textEditingController;

  set setListOfMessages(MessageModel messageModel)
  {
    _listOfMessages.add(messageModel);
    notifyListeners();
  }
  set setReceiverSignupModel(UserSignupModel userSignupModel)
  {
    _receiverSignupModel=userSignupModel;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
    _chatService.setIsUserRead(previousChatModel.chatId??"", thisUser, "no");

  }
}