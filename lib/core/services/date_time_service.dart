
class DateTimeService {
   late DateTime _dateTime;

   String getDMY({required int timeStamp})
   {
      List<String> months=["","January","February","March","April","May","June","July","August","September","October","November","December"];
       _dateTime=DateTime.fromMillisecondsSinceEpoch(timeStamp);
      String day=_dateTime.day.toString();
      String year=_dateTime.year.toString();
      String month=months[_dateTime.month];
      return "$day $month, $year";
   }

   String timeDifference(int d)
   {
      String timeAgo="";
      DateTime old=DateTime.fromMillisecondsSinceEpoch(d);
      DateTime latest=DateTime.now();
      Duration duration=latest.difference(old);
      int seconds=duration.inSeconds;
      int years=(seconds/31556952).round();
      int months=(seconds/2629746).round();
      int days=(seconds/86400).round();
      int hours=(seconds/3600).round();
      int minutes=(seconds/60).round();
      if(years>=1)
         {
           timeAgo="$years ${years==1?"yr":"yrs"} ago";
         }
      else
         {
            if(months>=1)
               {
                  timeAgo="$months ${months==1?"month":"months"} ago";
               }
            else
               {
                  if(days>=1)
                     {
                        timeAgo="$days ${days==1?"day":"days"} ago";
                     }
                  else
                     {
                        if(hours>=1)
                           {
                              timeAgo="$hours ${hours==1?"hr":"hrs"} ago";
                           }
                        else
                           {
                              if(minutes>=1)
                                 {
                                    timeAgo="$minutes ${minutes==1?"min":"mins"} ago";
                                 }
                              else
                                 {
                                    if(seconds>=1)
                                       {
                                          timeAgo="$seconds ${seconds==1?"secs":"secs"} ago";
                                       }
                                    else
                                       {
                                          timeAgo="0 secs ago";
                                       }

                                 }
                           }
                     }
               }
         }

      return timeAgo;

   }

   String getDate(String dt)
   {
      DateTime dateTime=DateTime.parse(dt);

      return dateTime.day.toString()+'/'+dateTime.month.toString()+'/'+dateTime.year.toString();
   }
   String getTime(String dt)
   {
      DateTime dateTime=DateTime.parse(dt);

      return dateTime.hour.toString()+':'+dateTime.minute.toString();
   }
}