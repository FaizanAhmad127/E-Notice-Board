

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notice_board/core/constants/colors.dart';
import 'package:notice_board/core/constants/text_styles.dart';
import 'package:notice_board/core/services/date_time_service.dart';
import 'package:notice_board/core/services/event/event_service.dart';
import 'package:notice_board/ui/custom_widgets/custom_user_tf/custom_user_tf.dart';
import 'package:notice_board/ui/custom_widgets/login_register_button/login_register_button.dart';
import 'package:notice_board/ui/screens/coordinator/coordinator_event_screen/coordinator_event_screen_vm.dart';
import 'package:provider/provider.dart';

class CoordinatorEventScreen extends StatelessWidget {
  const CoordinatorEventScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: DefaultTabController(
      length: 2,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text('Events'),
          bottom: PreferredSize(
            preferredSize: Size(1.sw,
              0.03.sh,),
            child: TabBar(
                labelStyle: kPoppinsRegular400.copyWith(
                  fontSize: 17
                ),
                unselectedLabelStyle:  kPoppinsRegular400.copyWith(
                    fontSize: 15
                ),
                indicatorColor: kAcceptedColor,
                tabs: [
              Text('Create Event'),
              Text('View Events'),
            ]),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context)=>CoordinatorEventScreenVM(),
          builder: (context,vm)
          {
            return Consumer<CoordinatorEventScreenVM>(builder: (context,vm,child)
            {
              return TabBarView(children: [

                ///
                /// Create Event
                ///
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.05.sh,
                    horizontal: 0.03.sw
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: vm.titleContrller,
                          decoration: InputDecoration(
                            hintText: 'Enter title here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 0
                              )
                            ),
                            label: Text('Title'),
                            labelStyle: kPoppinsRegular400.copyWith(
                              color: kPrimaryColor,
                              fontSize: 15
                            )
                          ),
                        ),
                        SizedBox(height: 0.05.sh,),
                        TextField(
                          controller: vm.addressController,
                          decoration: InputDecoration(
                              hintText: 'Enter Address here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 0
                                  )
                              ),
                              label: Text('Address or Room'),
                              labelStyle: kPoppinsRegular400.copyWith(
                                  color: kPrimaryColor,
                                  fontSize: 15
                              )
                          ),
                        ),
                        SizedBox(height: 0.05.sh,),
                        TextField(
                          controller: vm.descriptionController,
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: 'Enter Description here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 0
                                  )
                              ),
                              label: Text('Description',
                              ),
                              labelStyle: kPoppinsRegular400.copyWith(
                                  color: kPrimaryColor,
                                  fontSize: 15
                              )
                          ),
                        ),
                        SizedBox(height: 0.03.sh,),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: ()
                                {
                                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                                      onChanged: (date) {
                                        // print('change $date in time zone ' +
                                        //     date.timeZoneOffset.inHours.toString());
                                      }, onConfirm: (date) {
                                        vm.setPickedDateTime=date;
                                      }, currentTime: DateTime.now());
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(child: Icon(FontAwesomeIcons.clock,
                                      color: kAcceptedColor,)),
                                      SizedBox(width: 0.01.sw,),
                                      Expanded(
                                          flex: 2,
                                          child: FittedBox(
                                            child: Text('Pick date & time',
                                      style: kPoppinsRegular400.copyWith(
                                        color: kWhiteColor
                                      ),),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 0.05.sw,),
                            Expanded(
                               // flex: 2,
                                child: Text(vm.getPickedDateTime.isEmpty?'Date/Time will appear here..'
                                    :vm.getPickedDateTime))
                          ],
                        ),
                        SizedBox(height: 0.1.sh,),
                        Center(
                          child: LoginRegisterButton(
                              onPressed: (){
                                vm.createEvent().then((value){
                                  if(value==true)
                                    {
                                      //do something after event is created;
                                    }
                                });
                              }, buttonText: 'Create Event'),
                        )
                      ],
                    ),
                  ),
                ),
                ///
                /// View Events
                ///
                Padding(padding: EdgeInsets.all(15),
                child: vm.getListOfEvents.isEmpty?
                Center(
                  child: Text('List of events will appear here'),
                ):
                ListView.builder(
                    itemCount: vm.getListOfEvents.length,
                    itemBuilder: (context,index)
                    {
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 0.02.sh
                        ),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: kPrimaryColor
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    vm.getListOfEvents[index].title??'',
                                  style: kPoppinsSemiBold600.copyWith(
                                    fontSize: 18
                                  ),),
                                ),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: ()async
                                  {
                                    BotToast.showLoading();
                                    try
                                    {
                                      await EventService().
                                      deleteEvent(vm.getListOfEvents[index].id??'').then((value) {
                                        if(value==true)
                                        {
                                          vm.getListOfEvents.removeAt(index);
                                          vm.notifyListeners();
                                        }
                                      });
                                    }
                                    catch(error)
                                    {
                                      BotToast.showText(text: 'Oops! Something wrong happened');
                                    }
                                    BotToast.closeAllLoading();
                                  },
                                  child: const Icon(FontAwesomeIcons.trashCan,
                                  size: 20,),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Text('Date: ',
                                style: kPoppinsMedium500.copyWith(
                                  fontSize: 14
                                ),),
                                Text(DateTimeService().getDate(vm.getListOfEvents[index].dateTime??'')),
                                SizedBox(width: 40,),
                                Text('Time: ',
                                  style:kPoppinsMedium500.copyWith(
                                      fontSize: 14
                                  ),),
                                Text(DateTimeService().getTime(vm.getListOfEvents[index].dateTime??'')),

                              ],
                            ),
                            const SizedBox(height: 6,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Venue:    ',
                                  style: kPoppinsMedium500.copyWith(
                                      fontSize: 14
                                  ),),
                                Expanded(
                                    child: Text(vm.getListOfEvents[index].location??'')),


                              ],
                            ),
                            const SizedBox(height: 6,),
                            Text('Details of an event: ',
                            style: kPoppinsMedium500.copyWith(
                                fontSize: 14
                            ),),
                            Text(vm.getListOfEvents[index].description??'',
                            textAlign: TextAlign.justify,
                            style: kPoppinsRegular400.copyWith(

                            ),),
                          ],
                        ),
                      );
                    }),)
              ]);
            });
          },

        ),
      ),
    ));
  }
}
