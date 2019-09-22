import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_lib/components/drawer.dart';
import 'package:my_lib/components/recommendItem.dart';
import 'package:my_lib/crawler/library/library.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  LibraryRecommend recommend;
  String test;
  bool showLoading;

  @override
  Widget build(BuildContext context) {
    Widget _body;
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
                '推荐书目',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ...this.recommend.value.sublist(1, 10).map((item) =>
                new RecommendItem(
                    item.name, item.author, item.press, item.callNumber)),
            SizedBox(
              height: 20,
            )
          ],
        ),
      );
    }
    return new Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: ModalProgressHUD(
        child: _body,
        inAsyncCall: this.showLoading,
      ),
      drawer: new MyDrawer(),
    );
  }

  @override
  void initState() {
    super.initState();
    this.setState(() {
      this.test = '123';
      this.showLoading = true;
    });
    Library.recommend().then((res) {
      this.setState(() {
        this.recommend = res;
        this.showLoading = false;
      });
    });
  }
}
