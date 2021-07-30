import 'package:easy_http_request/easy_http_request.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(httpContract: Get.find<EasyHttpRequestContract>()));
  }
}
