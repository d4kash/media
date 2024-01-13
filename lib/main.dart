
import 'package:etech_tech/bindings/bindings.dart';
import 'package:etech_tech/service/download_manager.dart';
import 'package:etech_tech/view/VideoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialBinding: ControllerBinding(),
      // home: const Downloading(),
      home: const VideoPlayer(),
      
    );
  }
}
