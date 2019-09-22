import 'package:flutter/material.dart';

const String _title = '个人中心';

final Widget _body = Center(
  child: Text('personal'),
);

class Personal extends StatefulWidget {
  @override
  _Personal createState() => _Personal();
}

class _Personal extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _body,
//      drawer: new MyDrawer(),
    );
  }
}
