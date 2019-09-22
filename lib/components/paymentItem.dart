import 'package:flutter/material.dart';

class PaymentItem extends StatelessWidget {
  String id;
  String bookId;
  String name;
  String author;
  String borrowDate;
  String returnDate;
  String place;
  String expectPayment;
  String actualPayment;
  String status;
  PaymentItem(
      this.id,
      this.bookId,
      this.name,
      this.author,
      this.borrowDate,
      this.returnDate,
      this.place,
      this.expectPayment,
      this.actualPayment,
      this.status);

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
              leading: Text('位置'),
              title: Text(this.place),
            ),
            Divider(),
            ListTile(
              leading: Text('应缴费用'),
              title: Text(this.expectPayment),
            ),
            Divider(),
            ListTile(
              leading: Text('实际缴纳'),
              title: Text(this.actualPayment),
            ),
            Divider(),
            ListTile(
              leading: Text('状态'),
              title: Text(this.status),
            )
          ],
        ),
      ),
    );
  }
}
