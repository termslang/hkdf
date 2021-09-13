import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'RobotoMono',
        textTheme: TextTheme(
            headline1: TextStyle(
          fontFamily: 'RobotoMono',
        )),
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Controller controller = Get.put(Controller());
    return Scaffold(
      appBar: AppBar(
        title: const Text('hkdf'),
      ),
      body: Column(
        children: [
          Container(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.c,
                      decoration: const InputDecoration(hintText: 'Enter master key phrase'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        print(controller.c.text);
                        print(controller.items.length);
                        await controller.itemsGen(controller.c.text);
                      },
                      child: Text('GO'))
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.items[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
