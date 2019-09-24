import 'package:flutter/material.dart';
import 'package:my_njupt_library/crawler/library/library.dart';

class Search extends StatefulWidget {
  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  String keyword;
  @override
  Widget build(BuildContext context) {
    Widget _body = Center(
        child: Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 60,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: true,
            decoration: new InputDecoration(
              hintText: '请输入关键字',
              contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),
            onChanged: (value) {
              this.keyword = value;
            },
          ),
          RaisedButton(
            child:
                Text('搜索', style: TextStyle(color: Colors.white, fontSize: 16)),
            color: Colors.blue,
            onPressed: () async {
              print(this.keyword);
              LibrarySearch search = await Library.search(name: this.keyword);
              print(search.value);
            },
          )
        ],
      ),
    ));
    return new Scaffold(
      appBar: AppBar(
        title: Text('搜索'),
      ),
      body: _body,
    );
  }
}
