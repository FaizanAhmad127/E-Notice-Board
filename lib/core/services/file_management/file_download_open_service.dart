import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileDownloadOpenService{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;

  Future<void> downloadFile(String url) async {
    BotToast.showText(text: "Opening File...");
    Reference ref=_firebaseStorage.refFromURL(url);
    late File tempFile;
    try
    {
      BotToast.showLoading();
      PermissionStatus status=await Permission.storage.request();
      if(status.isGranted)
      {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        tempFile= File(appDocPath + '/' + ref.name);

        await ref.writeToFile(tempFile).then((p0) async{
          await tempFile.create().then((value) async{
            await OpenFile.open(tempFile.path);
          });
        });

      }
      else
      {
        BotToast.showText(text: "Permission needed first");
      }


    }
    catch(error)
    {
      BotToast.showText(text: "Sorry unable to load file, try again");
    }
    BotToast.closeAllLoading();




  }
}