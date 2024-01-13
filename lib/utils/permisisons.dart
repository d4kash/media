import 'dart:io';



import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:etech_tech/constants/constants.dart';
import 'package:etech_tech/utils/extPermission.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class GetPermissions{
  static void  checkallpermission_openstorage() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 32) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.photos, Permission.notification].request();

      if (await statuses[Permission.photos]!.isGranted ||
          statuses[Permission.notification]!.isGranted) {
      } else {
        Constant.showSnackBar(
            Get.context!, "Please give permissions for smooth functioning");
        // Fluttertoast.showToast(
        //     msg:
        //
        //        "Provide Storage or Notification permission for better performance.");
        await Future.delayed(Duration(seconds: 1))
            .then((value) => openAppSettings());
      }
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage, Permission.notification].request();

      if (await statuses[Permission.storage]!.isGranted) {
      } else {
        Constant.showSnackBar(
            Get.context!, "Please give permissions for smooth functioning");
        await Future.delayed(Duration(seconds: 2))
            .then((value) => openAppSettings());
      }
    }
  }



  static  void downloadRecording(String downloadUrl) async {
    // checkallpermission_openstorage();
    final Dio dio = Dio();
    String url = downloadUrl;
    var splittedUrl = downloadUrl.split('/');
    String fileName = splittedUrl[4];
    String path = await getFilePath(fileName);
Constant.showSnackBar(Get.context!, '${fileName} Started Downloading');
    await dio.download(
      url,
      path,
      onReceiveProgress: (receivedBytes, totalBytes) {
       // Fluttertoast.showToast(msg: '${fileName} Started Downloading',toastLength: Toast.LENGTH_LONG);
       Constant.showSnackBar(Get.context!, '${fileName} Started Downloading');
        print("Rec: $receivedBytes , Total: $totalBytes");

        // setState(() {
        var progress = ((receivedBytes / totalBytes) * 100);
        if (progress == 100.0) {
          _saveFileToRecordings(path);
         // Fluttertoast.showToast(msg: 'Pdf ${fileName} saved to Downloads',toastLength: Toast.LENGTH_LONG);
        }
        // });
      },
      deleteOnError: true,
    );
    // .then((value) {
    //   // File file = File(path);
    //   // file.writeAsBytes(value.data.bodyBytes);
    //   print("fetched Downloaded Value: ${value.data.toString()}");
    // });
  }
  
  static Future _saveFileToRecordings(String path) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print("Device Version: ${androidInfo.version.sdkInt}");

    if (Platform.isAndroid && androidInfo.version.sdkInt >= 29) {
      try {
        // openfile(path);
        // await platform.invokeMethod('saveFile', {'path': path});
      } on PlatformException catch (e) {
        print(e);
      }
    } else {}
  }

 static  Future getFilePath(String fileName) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print("Device Version: ${androidInfo.version.sdkInt}");
    final path = await FileStorage.localPath;
    if (Platform.isAndroid && androidInfo.version.sdkInt >= 29) {
      // final dir = await getExternalStorageDirectory();/
      print("File Name: ${path}/video_$fileName");
      return "$path/video_$fileName";
    } else {
      // var dir = Directory('/storage/emulated/0/Download');
      print("File Name: ${path}/video_$fileName");
      return "${path}/video_$fileName";
    }
  }
}