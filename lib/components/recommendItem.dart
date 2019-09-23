import 'package:flutter/material.dart';
import 'package:my_njupt_library/components/common/CommonItemsConstructor.dart';

class RecommendItem extends StatelessWidget {
  Map<String, String> items = new Map();
  RecommendItem(String name, String author, String press, String callNumber) {
    items['书名'] = name;
    items['作者'] = author;
    items['出版社'] = press;
    items['编号'] = callNumber;
  }
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Column(children: CommonItemsConstructor(this.items)),
      ),
    );
  }
}
