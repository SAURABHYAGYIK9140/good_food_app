import 'package:get/get.dart';

import '../controllers/ConnectivityController.dart';

class ConnectivityBinding extends Bindings
{
  @override
  void dependencies() {
    Get.lazyPut<ConnectivityController>(()=> ConnectivityController());
  }

}