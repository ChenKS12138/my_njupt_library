import 'package:flutter/material.dart';

import 'common/CommonItemsConstructor.dart';

class HistoryItem extends StatelessWidget {
  Map<String, String> items = new Map();
  HistoryItem(String id, String name, String author, String borrowDate,
      String returnDate, String place) {
    items['书名'] = name;
    items['作者'] = author;
    items['借阅时间'] = borrowDate;
    items['归还时间'] = returnDate;
    items['地点'] = place;
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Column(
          children: CommonItemsConstructor(this.items),
        ),
      ),
    );
  }
}
