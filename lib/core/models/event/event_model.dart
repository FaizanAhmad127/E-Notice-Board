class EventModel
{

  String ? dateTime;
  String ? title;
  String ? location;
  String ? description;
  String ? id;

  EventModel(this.id,this.dateTime,this.title,this.description,this.location);

  EventModel.fromJson(dynamic json)
  {
    id=json['id'];
    dateTime=json['dateTime'];
    title=json['title'];
    description=json['description'];
    location=json['location'];
  }

  Map<String,dynamic> toJson() {
    Map<String, dynamic> map = {};

    map['id']=id;
    map['dateTime'] = dateTime;
    map['title'] = title;
    map['description'] = description;
    map['location'] = location;

    return map;
  }
}