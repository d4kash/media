import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:etech_tech/constants/constants.dart';
import 'package:etech_tech/utils/extPermission.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class DownloadFunctions {
  downloadRecording(String downloadUrl) async {
    // checkallpermission_openstorage();
    final Dio dio = Dio();
    String url = downloadUrl;
    var splittedUrl = downloadUrl.split('/');
    String fileName = splittedUrl[5];
    print("fileName: $fileName");
    String path = await _getFilePath(fileName);
    // Constant.showSnackBar(Get.context!, '${fileName} Started Downloading');
    await dio.download(
      url,
      path,
      onReceiveProgress: (receivedBytes, totalBytes) {
         print("Rec: $receivedBytes , Total: $totalBytes");
       // setState(() {
        var progress = ((receivedBytes / totalBytes) * 100);
        if (progress == 100.0) {
          Constant.showSnackBar(Get.context!, '${fileName} Download Complete');
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

  static openfile(String filePath) {
    OpenFile.open(filePath);
    print("fff $filePath");
    //  Fluttertoast.showToast(msg: 'Pdf/Image Saved to Downloads',toastLength: Toast.LENGTH_SHORT);
  }

  static Future _saveFileToRecordings(String path) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print("Device Version: ${androidInfo.version.sdkInt}");

    if (Platform.isAndroid && androidInfo.version.sdkInt >= 29) {
      try {
        openfile(path);
        // await platform.invokeMethod('saveFile', {'path': path});
      } on PlatformException catch (e) {
        print(e);
      }
    } else {}
  }

  static Future _getFilePath(String fileName) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print("Device Version: ${androidInfo.version.sdkInt}");
    final path = await FileStorage.localPath;
    if (Platform.isAndroid && androidInfo.version.sdkInt >= 29) {
      // final dir = await getExternalStorageDirectory();/
      print("File Name: ${path}/media_$fileName");
      return "$path/media_$fileName";
    } else {
      // var dir = Directory('/storage/emulated/0/Download');
      print("File Name: ${path}/media_$fileName");
      return "${path}/media_$fileName";
    }
  }
}
