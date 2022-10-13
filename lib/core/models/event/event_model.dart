class EventModel
{

  String ? dateTime;
  String ? title;
  List<String>  stdList=[];
  String ? location;
  String ? description;
  String ? id;

  EventModel(this.id,this.dateTime,this.title,this.stdList,this.description,this.location);

  EventModel.fromJson(dynamic json)
  {
    id=json['id'];
    dateTime=json['dateTime'];
    title=json['title'];
    stdList=json['stdList'].cast<String>();
    description=json['description'];
    location=json['location'];
  }

  Map<String,dynamic> toJson() {
    Map<String, dynamic> map = {};

    map['id']=id;
    map['dateTime'] = dateTime;
    map['title'] = title;
    map['stdList'] = stdList;
    map['stdList'] = stdList;
    map['description'] = description;
    map['location'] = location;

    return map;
  }
}