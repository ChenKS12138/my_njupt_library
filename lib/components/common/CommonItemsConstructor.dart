import 'package:flutter/material.dart';

List<Widget> CommonItemsConstructor(Map<String, String> source) {
  List<Widget> result = new List();
  source.forEach((key, value) {
    result.add(Divider());
    result.add(ListTile(
      leading: Text(key),
      title: Text(value),
    ));
  });
  return result.sublist(1);
}
