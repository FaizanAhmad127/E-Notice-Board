import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/user_authentication/user_signup_model.dart';
import 'package:notice_board/core/services/chat/chat_service.dart';
import 'package:notice_board/core/services/user_documents/user_profile_service.dart';

import '../../../core/models/chat/chat_model.dart';

class ChatScreenVM extends ChangeNotifier {
  final ChatService _chatService = GetIt.I.get<ChatService>();
  final UserProfileService _userProfileService =
      GetIt.I.get<UserProfileService>();
  final Logger _logger = Logger();
  List<ChatModel> _listOfChatModel = [];
  String uid = "";
  String userType;
  bool isDispose=false;

  ChatScreenVM(this.userType,this.uid) {

    getChats();
  }
  Future<UserSignupModel?> getOppositeUserProfile(String? uuid, String? userT)async{
    UserSignupModel? user=await _userProfileService.getProfileDocument(uuid!, userT!);
    return user;
  }

  Future getChats() async {
    List<String> chatIds=[];
    try {
      await _userProfileService
          .getProfileDocument(uid, userType)
          .then((docSnap) {
        chatIds=docSnap?.chatList??[];
      }).then((value) {

        if(chatIds.isNotEmpty)
          {
            Future.forEach(chatIds, (String chatId) {

               _chatService.getChatDocument(chatId).onData((docSnap) {
                 if(isDispose==false)
                   {
                     setListOfChatModel=ChatModel.fromJson(docSnap);
                   }

              });

            });
      }});
    } catch (error) {
      _logger.e("error at getChats / ChatScreenVM $error");
    }
  }

  List<ChatModel> get listOfChatModel => _listOfChatModel;

  set setListOfChatModel(ChatModel chatModel)
  {
    int index=0;
    bool isChatIdAlreadyInList=false;
    _listOfChatModel.forEach((element) {
      if(element.chatId==chatModel.chatId)
        {
          _listOfChatModel[index]=chatModel;
          isChatIdAlreadyInList=true;
        }
      index++;
    });
    if(isChatIdAlreadyInList==false)
      {
        _listOfChatModel.add(chatModel);
      }

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose=true;
  }
}
