
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {

  String? _chatId;
  int? _createdTimeStamp;
  String _isUser1Read="yes";
  String _isUser2Read="yes";
  String? _recentText="";
  int? _recentTextTime=Timestamp.now().millisecondsSinceEpoch;
  String? _user1Uid;
  String? _user2Uid;
  String? _user1Occupation;
  String? _user2Occupation;
  int _user1UnReadCount=0;
  int _user2UnReadCount=0;
  //List<MessageModel> _listOfMessages=[];

  ChatModel(this._chatId,this._createdTimeStamp,this._user1Uid,this._user2Uid,this._user1Occupation,this._user2Occupation);

  /// Getters
  String? get chatId => _chatId;
  int? get createdTimeStamp => _createdTimeStamp;
  String get isUser1Read => _isUser1Read;
  String get isUser2Read => _isUser2Read;
  String? get recentText => _recentText;
  int? get recentTextTime => _recentTextTime;
  String? get user1Uid => _user1Uid;
  String? get user2Uid => _user2Uid;
  String? get user1Occupation => _user1Occupation;
  String? get user2Occupation => _user2Occupation;
  int get user1UnReadCount => _user1UnReadCount;
  int get user2UnReadCount => _user2UnReadCount;
 // List<MessageModel> get listOfMessages=>_listOfMessages;

  ChatModel.fromJson(dynamic json){
    _chatId=json['chatId'];
    _createdTimeStamp=json['createdTimeStamp'];
    _isUser1Read=json['isUser1Read'];
    _isUser2Read=json['isUser2Read'];
    _recentText=json['recentText'];
    _recentTextTime=json['recentTextTime'];
    _user1Uid=json['user1Uid'];
    _user2Uid=json['user2Uid'];
    _user1Occupation=json['user1Occupation'];
    _user2Occupation=json['user2Occupation'];
    _user1UnReadCount=json['user1UnreadCount'];
    _user2UnReadCount=json['user2UnreadCount'];

    // Iterable list=json['messages'];
    // _listOfMessages = list.map((i) =>
    //     MessageModel.fromJson(i)).toList();

  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map={};

    map['chatId']=_chatId;
    map['createdTimeStamp']=_createdTimeStamp;
    map['isUser1Read']=_isUser1Read;
    map['isUser2Read']=_isUser2Read;
    map['recentText']=_recentText;
    map['recentTextTime']=_recentTextTime;
    map['user1Uid']=_user1Uid;
    map['user2Uid']=_user2Uid;
    map['user1Occupation']=_user1Occupation;
    map['user2Occupation']=_user2Occupation;
    map['user1UnreadCount']=_user1UnReadCount;
    map['user2UnreadCount']=_user2UnReadCount;
    return map;
  }

}