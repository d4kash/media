import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:etech_tech/Network/connectivity_controller.dart';
import 'package:get/get.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies

    /* Networking */
    Get.put<Connectivity>(Connectivity(), permanent: true);
    Get.put<ConnectivityService>(ConnectivityService(Get.find<Connectivity>()),
        permanent: true);
  }
}
