
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
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

 Future<List<PlatformFile>> multipleFilePicker()async
 {
   List<PlatformFile> files=[];
   try
       {
         PermissionStatus status=await Permission.storage.request();
         if(status.isGranted)
           {
             FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
             if (result == null) return [];

            // List<File> files = result.paths.map((path) => File(path!)).toList();
               files =result.files;
           }
         else
           {
             BotToast.showText(text: "Permission needed first");
           }

       }
   catch(error){
     _logger.e('error at multipleFilePicker/FilePickerImage.dart');
   }
   return files;
 }

 Future<PlatformFile?> singleFilePicker()async
 {
   PlatformFile? file;
   try
   {
     PermissionStatus status=await Permission.storage.request();
     if(status.isGranted)
     {
       FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
       if (result == null) return null;
           file =result.files.first;
     }
     else
     {
       BotToast.showText(text: "Permission needed first");
     }

   }
   catch(error){
     _logger.e('error at multipleFilePicker/FilePickerImage.dart');
   }
   return file;
 }


}