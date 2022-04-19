import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherMarksScreenVM extends ChangeNotifier{

  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  String uid="";

  TeacherMarksScreenVM()
  {
    uid=_firebaseAuth.currentUser!.uid;
  }
}