import 'package:flutter/material.dart';

const String _title = '搜索';

final Widget _body = Center(
  child: Text('搜索'),
);

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _body,
//      drawer: new MyDrawer(),
    );
  }
}
