import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class VideoListService extends GetxController {
    Dio dio = Dio();
  Future<String> getVideoList(String standard) async {
    try {
      var response = await dio.post(
          'https://e03z6w1g0c.execute-api.ap-south-1.amazonaws.com/erp/erp_get_videos',
          
          );

      if (response.data['body-json']['statusCode'] == 200) {
        
        return json.encode(response.data['body-json']["body"]['Items']);
      } else {
        return "";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }
}
