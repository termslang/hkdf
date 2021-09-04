import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';

void main() async {
  List<String> items = [];

  var stream = Stream<int>.fromIterable(Iterable<int>.generate(256, (x) => x));
  await for (int i in stream) {
    items.add(await stringForStringWithIndex('string', i));
  }

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
      home: MyApp(items: items),
    ),
  );
}

Future<String> stringForStringWithIndex(String string, int index) async {
  final message = <int>[1, 2, 3];
  final hash = await Sha256().hash(message);
  final secretKey = SecretKey(hash.bytes);

  final algorithm = Hkdf(
    hmac: Hmac(Sha256()),
    outputLength: 32,
  );
  final nonce = [index];

  SecretKey k = await algorithm.deriveKey(
    secretKey: secretKey,
    nonce: nonce,
  );

  var out = await k.extractBytes();
  var value = '';
  for (int i in out) value += i.toRadixString(16);
  return value.toUpperCase();
}

class MyApp extends StatefulWidget {
  final List<String> items;

  const MyApp({Key? key, required this.items}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hkdf'),
      ),
      body: Column(
        children: [
          Container(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: 'Enter a search term'),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text(controller.text),
                            );
                          },
                        );
                      },
                      child: Text('Go'))
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
