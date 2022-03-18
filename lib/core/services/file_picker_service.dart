
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:notice_board/core/constants/strings.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerService
{
 final Logger _logger=Logger();

 Future<File> imagePicker() async
 {
    final _picker = ImagePicker();
    XFile? image;
    late File file;
  //  Image images=Image(image: NetworkImage(noImageUrl));

    try
         {
           //Check Permissions
           await Permission.photos.request();
            var permissionStatus = await Permission.photos.status;

           if (permissionStatus.isGranted)
           {
             //Select Image
             image = await _picker.pickImage(source: ImageSource.gallery);
             file = File(image!.path);
               //
               // List<int> imageBase64 = file.readAsBytesSync();
               // String imageAsString = base64Encode(imageBase64);
               // Uint8List uint8list = base64.decode(imageAsString);
               // images = Image.memory(uint8list);


           }
          else {
             BotToast.showText(text: "Permission needed first");
          }
        }
    catch(error){
     _logger.e('error at pickimage/FilePickerImage.dart');
   }
    return file;

 }


}