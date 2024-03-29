import 'package:flutter/material.dart';
import 'package:my_njupt_library/components/paymentItem.dart';
import 'package:my_njupt_library/store.dart';
import 'package:provider/provider.dart';

const String _title = '违章情况';

class Payment extends StatefulWidget {
  @override
  _Payment createState() => _Payment();
}

class _Payment extends State<Payment> {
  bool showLoading;
  @override
  Widget build(BuildContext context) {
    Widget _body;
    List payment = Provider.of<Store>(context).payment;
    if (this.showLoading) {
      _body = Center(
        heightFactor: 12,
        child: Text(
          '加载中...',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      if (payment != null) {
        _body = Center(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  '违章情况',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ...payment.map((item) => new PaymentItem(
                  item.id,
                  item.bookId,
                  item.name,
                  item.author,
                  item.borrowDate,
                  item.returnDate,
                  item.place,
                  item.expectPayment,
                  item.actualPayment,
                  item.status)),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      } else {
        _body = Center(
          child: Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '暂无违章情况数据',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        );
      }
    }

    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _body,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      this.showLoading = false;
    });
  }
}
