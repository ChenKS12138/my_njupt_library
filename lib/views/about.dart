import 'package:flutter/material.dart';

const String _title = '关于';

final Widget _body = Center(
  child: Column(children: <Widget>[
    Padding(
      padding: EdgeInsets.only(top: 40),
    ),
    Container(
        width: 120,
        height: 120,
        child: Image.asset('lib/assets/images/author.png')),
    Padding(
      padding: EdgeInsets.only(top: 30),
    ),
    Text(
      'My NJUPT Library',
      style: TextStyle(fontSize: 24),
    ),
    Padding(
      padding: EdgeInsets.only(top: 60),
    ),
    Text('Flutter Demo'),
  ]),
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
