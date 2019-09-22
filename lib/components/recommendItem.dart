import 'package:flutter/material.dart';

class RecommendItem extends StatelessWidget {
  String name;
  String author;
  String press;
  String callNumber;
  int store;
  int borrowCount;
  int borrowRate;
  String marc_no;
  RecommendItem(this.name, this.author, this.press, this.callNumber);

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(this.name),
              leading: Text('书名'),
            ),
            Divider(),
            ListTile(
              leading: Text('作者'),
              title: Text(this.author),
            ),
            Divider(),
            ListTile(
              leading: Text('出版社'),
              title: Text(this.press),
            ),
            Divider(),
            ListTile(
              leading: Text('编号'),
              title: Text(this.callNumber),
            )
          ],
        ),
      ),
    );
  }
}
