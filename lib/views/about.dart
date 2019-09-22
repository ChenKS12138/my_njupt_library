import 'package:flutter/material.dart';

const String _title = '关于';

final Widget _body = Center(
  child: Column(
    children: <Widget>[
      Container(
          width: 180,
          height: 180,
          child: Image.asset('lib/assets/images/author.png')),
      Padding(
        padding: EdgeInsets.only(top: 30),
      ),
      Text(
        'My Library',
        style: TextStyle(fontSize: 28),
      ),
      Padding(
        padding: EdgeInsets.only(top: 20),
      ),
      Text('这是个flutter的demo，用于交流学习'),
      Padding(
        padding: EdgeInsets.only(top: 16),
      ),
      Container(
        child: Image.asset('lib/assets/images/github.png'),
        width: 80,
        height: 80,
      )
    ],
  ),
);

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _body,
//      drawer: new MyDrawer(),
    );
  }
}
