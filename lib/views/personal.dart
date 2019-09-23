import 'package:flutter/material.dart';
import 'package:my_njupt_library/crawler/library/library.dart';
import 'package:my_njupt_library/store.dart';
import 'package:provider/provider.dart';

const String _title = '个人中心';

class Personal extends StatefulWidget {
  @override
  _Personal createState() => _Personal();
}

///五天内应还书目，姓名，学号，最大借阅数，学生类别，借阅等级，欠费，学院，累计借阅数

class _Personal extends State<Personal> {
  @override
  Widget build(BuildContext context) {
    LibraryPersonalInfo personalInfo = Provider.of<Store>(context).personalInfo;
    String rank = Provider.of<Store>(context).rank;
    return new Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                '个人中心',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              child: new Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Text('姓名'),
                      title: Text(personalInfo.name),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('学号'),
                      title: Text(personalInfo.studentID),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('学院'),
                      title: Text(personalInfo.department),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('学生类别'),
                      title: Text(personalInfo.studentType),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('五天内应还书目'),
                      title: Text(personalInfo.dueInFive),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('欠费'),
                      title: Text(personalInfo.arrear + '元'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('借阅排名'),
                      title: Text((double.parse(rank) * 100).toString() + '%'),
                    ),
                    ListTile(
                      leading: Text('累计借阅数'),
                      title: Text(personalInfo.accumulatedCount),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('最大借阅数'),
                      title: Text(personalInfo.maxBorrowCount),
                    ),
                    Divider(),
                    ListTile(
                      leading: Text('借阅等级'),
                      title: Text(personalInfo.borrowLevel),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
//      drawer: new MyDrawer(),
    );
  }
}
