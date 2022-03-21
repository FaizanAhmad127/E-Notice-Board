class FileModel {

  String _fileName="";
  String _fileExtension="";
  String _fileUrl="";
  int _fileSize=0;

  FileModel(this._fileName,this._fileExtension,this._fileUrl,this._fileSize);

  String get fileExtension => _fileExtension;

  String get fileUrl => _fileUrl;

  int get fileSize => _fileSize;

  String get fileName => _fileName;


  FileModel.fromJson(dynamic json)
  {
    _fileName=json['fileName'];
    _fileExtension=json['fileExtension'];
    _fileUrl=json['fileUrl'];
    _fileSize=json['fileSize'];

  }

  Map<String,dynamic> toJson()
  {
    Map<String,dynamic> map={};
    map['fileName']=_fileName;
    map['fileExtension']=_fileExtension;
    map['fileUrl']=_fileUrl;
    map['fileSize']=_fileSize;
    return map;
  }


}