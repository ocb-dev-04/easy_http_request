import 'package:easy_http_request/data/easy_http_request_models.dart';
import 'package:easy_http_request/easy_http_request.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initilize packge info
  EasyHttpRequest.init(config: HttpConfigData(baseApi: 'https://jsonplaceholder.typicode.com'));
  runApp(const App());
}

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "EHR With Getx DI", // EHR = Easy Http Request
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: MainBindings(),
    );
  }
}

class MainBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EasyHttpRequestContract>(() => EasyHttpRequest());
  }
}
