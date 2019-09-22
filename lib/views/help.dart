import 'package:flutter/material.dart';

const String _title = '帮助与反馈';

final Widget _body = Center(
    child: Column(
  children: <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 40),
    ),
    Text(
      '遇到bug怎么办?',
      style: TextStyle(fontSize: 26),
    ),
    Padding(
      padding: EdgeInsets.only(top: 20),
    ),
    Text(
      '我的推荐是自己修',
      style: TextStyle(fontSize: 18),
    )
  ],
));

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _body,
//      drawer: new MyDrawer(),
    );
  }
}
