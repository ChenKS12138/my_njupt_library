import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  String id;
  String name;
  String author;
  String borrowDate;
  String returnDate;
  String place;
  HistoryItem(this.id, this.name, this.author, this.borrowDate, this.returnDate,
      this.place);

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
              leading: Text('书名'),
              title: Text(this.name),
            ),
            Divider(),
            ListTile(
              leading: Text('作者'),
              title: Text(this.author),
            ),
            Divider(),
            ListTile(
              leading: Text('借阅时间'),
              title: Text(this.borrowDate),
            ),
            Divider(),
            ListTile(
              leading: Text('归还时间'),
              title: Text(this.returnDate),
            ),
            Divider(),
            ListTile(
              leading: Text('地点'),
              title: Text(this.place),
            ),
          ],
        ),
      ),
    );
  }
}
