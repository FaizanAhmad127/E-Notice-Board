import 'dart:async';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/models/event/event_model.dart';

class EventService{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();


  Future<bool> createEvent(EventModel eventModel)async
  {

    try
    {
      await _firebaseFirestore.collection('event').doc(eventModel.id)
          .set(eventModel.toJson());
    }
    catch(error)
    {
      _logger.e('error at createEvent / EventService $error');
      BotToast.showText(text: 'Oops! Something wrong happened');
      return false;
    }
    return true;
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getListOfEvents()
  {
    late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
    streamSubscription;

    try
    {
      streamSubscription= _firebaseFirestore.collection('event')
          .snapshots().listen((event) { });
    }
    catch(error)
    {
      _logger.e('error at getListOfEvents / EventService $error');
      BotToast.showText(text: 'Oops! Something wrong happened');
    }

    return streamSubscription;
  }

  Future<bool> deleteEvent(String eventId)async
  {
    try
    {
      await _firebaseFirestore.collection('event').doc(eventId).delete();
    }
    catch(error)
    {
      _logger.e('error at deleteEvent / EventService $error');
      BotToast.showText(text: 'Oops! Something wrong happened');
      return false;
    }
    return true;
  }

}