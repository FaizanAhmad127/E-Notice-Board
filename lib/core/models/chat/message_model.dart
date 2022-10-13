import 'package:notice_board/core/models/idea/file_model.dart';

class MessageModel {

  String? _text;
  String? _sentBy;
  int? _timeStamp;
  FileModel? _file;

  MessageModel(this._text,this._sentBy,this._timeStamp,this._file);

  String? get text => _text;

  String? get sentBy => _sentBy;

  int? get timeStamp => _timeStamp;

  FileModel? get fileModel => _file;

  MessageModel.fromJson(dynamic json){
    _text = json['text'];
    _sentBy = json['sentBy'];
    _timeStamp = json['timeStamp'];
    _file = FileModel.fromJson(json['file']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map['text'] = _text;
    map['sentBy'] = _sentBy;
    map['timeStamp'] = _timeStamp;
    map['file'] = _file?.toJson()??{};

    return map;
  }
}