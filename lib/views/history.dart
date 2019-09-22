import 'package:flutter/material.dart';
import 'package:my_lib/components/historyItem.dart';
import 'package:my_lib/store.dart';
import 'package:provider/provider.dart';

const String _title = '借阅历史';

class History extends StatefulWidget {
  @override
  _History createState() => _History();
}

class _History extends State<History> {
  bool showLoading;
  @override
  void initState() {
    this.setState(() {
      this.showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _body;
    List history = Provider.of<Store>(context).history;
    print(history);
    if (this.showLoading) {
      _body = Center(
        heightFactor: 12,
        child: Text(
          '加载中...',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      _body = Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '借阅历史',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ...history.map((item) => new HistoryItem(item.id, item.name,
                item.author, item.borrowDate, item.returnDate, item.place)),
            SizedBox(
              height: 20,
            )
          ],
        ),
      );
    }

    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _body,
    );
  }
}
