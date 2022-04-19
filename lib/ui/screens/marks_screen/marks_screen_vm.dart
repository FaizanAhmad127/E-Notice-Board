import 'package:flutter/material.dart';

class MarksScreenVM extends ChangeNotifier{
  final TextEditingController _searchTFController=TextEditingController();

  MarksScreenVM(){
  }


  TextEditingController get searchTFController=>_searchTFController;
}