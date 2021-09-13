import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';
import 'package:get/get.dart';


class Controller extends GetxController {
  final RxList items = [].obs;
  final c = TextEditingController();

  itemsGen(String str) async {
    Future<String> stringForStringWithIndex(String string, int index) async {
      final message = utf8.encode(string);
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
    var _items = [];
    var stream = Stream<int>.fromIterable(Iterable<int>.generate(256, (x) => x));
    await for (int i in stream) {
      _items.add(await stringForStringWithIndex(str, i));
    }
    items.clear();
    items.addAll(_items);
  }
}

