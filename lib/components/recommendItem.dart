import 'package:flutter/material.dart';

import './common/CommonItemsConstructor.dart';

class RecommendItem extends StatefulWidget {
  Map<String, String> items = new Map();
  @override
  _RecommendItemState createState() => _RecommendItemState(items);
  RecommendItem(String name, String author, String press, String callNumber) {
    items['书名'] = name;
    items['作者'] = author;
    items['出版社'] = press;
    items['编号'] = callNumber;
  }
}

class _RecommendItemState extends State<RecommendItem> {
  Map<String, String> items = new Map();
  bool isExpanded = false;

  _RecommendItemState(Map<String, String> items) : items = items;
  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
//        child: Column(children: CommonItemsConstructor(this.items)),
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            this.setState(() {
              this.isExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text(items['书名']),
                  );
                },
                isExpanded: this.isExpanded,
                body: Column(children: CommonItemsConstructor(this.items))),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
