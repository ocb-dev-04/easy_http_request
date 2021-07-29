import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EHR With Getx DI'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () => controller.getOne(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('Get One', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => controller.getCollection(),
              color: Theme.of(context).primaryColor,
              child: Text('Get Many', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => controller.post(),
              color: Theme.of(context).primaryColor,
              child: Text('POST', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => controller.put(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('PUT', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => controller.patch(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('PATCH', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () => controller.delete(id: 1),
              color: Theme.of(context).primaryColor,
              child: Text('DELETE', style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
