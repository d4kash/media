import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Constant {

   static String image_base_url =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample';
 static double height = Get.size.height;
  static double width = Get.size.width;
  static String apiUrl = 'assets/api/videos_api.json';
static  Color buttonColor=const Color(0xffDCF2F1);
    static double textScaleFactor = MediaQuery.of(Get.context!).textScaleFactor;

 static showSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

static errorNetworkBanner(BuildContext context) {
    return ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      content: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           const Icon(
              Icons.cloud_off_outlined,
              color: Colors.white,
              size: 30,
            ),
          const  SizedBox(
              width: 4,
            ),
            Text(
              'No internet Connection!',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white, fontSize: 14),
            )
          ],
        ),
      ),
      actions: [Container()],
      backgroundColor: Colors.black,
    ));
  }




static showErrorSnackBar(){
Get.snackbar("Message", "Error",
            titleText: const Text(
              "Message",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            messageText: const Text(
              "Something went wrong",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white);}

}
