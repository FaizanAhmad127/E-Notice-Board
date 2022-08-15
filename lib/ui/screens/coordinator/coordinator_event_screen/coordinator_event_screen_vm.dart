import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notice_board/core/models/event/event_model.dart';
import 'package:notice_board/core/services/event/event_service.dart';
import 'package:notice_board/core/services/navigation_service.dart';
import 'package:notice_board/core/services/validate_service.dart';

class CoordinatorEventScreenVM extends ChangeNotifier
{
    TextEditingController titleContrller=TextEditingController();
    TextEditingController addressController=TextEditingController();
    TextEditingController descriptionController=TextEditingController();
    String _pickedDateTime='';
    List<EventModel> _listOfEvents=[];
    EventService eventService=EventService();


    CoordinatorEventScreenVM()
    {
        getAllEvents();
    }

    void getAllEvents()
    {
        try
        {
            eventService.getListOfEvents().onData((data) {
                data.docs.forEach((element) {
                    EventModel model=EventModel.fromJson(element.data());
                   if(getListOfEvents.where((element) => element.id==model.id).isEmpty)
                       {
                           setListOfEvents=model;
                       }

                });
            });
        }
        catch(error)
        {
            print('error at getAllEvents /CoordinatorEventScreenVm $error');
        }


    }

    Future<bool> createEvent()async
    {
        String id=Timestamp.now().millisecondsSinceEpoch.toString();
        BotToast.showLoading();
        bool isEventCreated=false;
        bool isValidate=Validate().validateEvent(titleContrller.text,
            addressController.text, descriptionController.text, getPickedDateTime);
        if(isValidate)
            {
               await eventService.createEvent(
                    EventModel(id,getPickedDateTime, titleContrller.text,
                        descriptionController.text, addressController.text)).then((value) {

                            if(value==true)
                                {
                                    BotToast.showText(text: 'Event Created');
                                    isEventCreated= true;
                                }
                            else
                                {
                                    isEventCreated= false;
                                }
                });
            }
        BotToast.closeAllLoading();
        return isEventCreated;
    }

    String get getPickedDateTime=>_pickedDateTime;
    List<EventModel> get getListOfEvents=>_listOfEvents;

    set setPickedDateTime(DateTime dateTime)
    {
        _pickedDateTime=dateTime.toString();
        print(DateTime.parse(_pickedDateTime));
        notifyListeners();
    }
    set setListOfEvents(EventModel eventModel)
    {
        _listOfEvents.add(eventModel);
        notifyListeners();
    }

    @override
    void dispose()
    {
        super.dispose();
        print('dispose is called');

    }
}