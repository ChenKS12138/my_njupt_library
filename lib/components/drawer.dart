import 'package:flutter/material.dart';
import 'package:my_njupt_library/store.dart';
import 'package:provider/provider.dart';

const BASE_PATH = 'lib/assets/icons';
const ICON_SEACH = '$BASE_PATH/Search.png';
const ICON_PAY = '$BASE_PATH/list-pay.png';
const ICON_HISTORY = '$BASE_PATH/history.png';
const ICON_HELP = '$BASE_PATH/help.png';
const ICON_ABOUT = '$BASE_PATH/about.png';
const ICON_INDEX = '$BASE_PATH/shouye.png';

class DrawerItem extends StatelessWidget {
  String text;
  String icon;
  Function next = () => {};
  final TextStyle style = TextStyle(fontSize: 22);
  DrawerItem(this.text, this.icon, [this.next]);
  @override
  build(BuildContext context) {
    return new ListTile(
      title: Text(
        text,
      ),
      leading: Image.asset(
        this.icon,
        height: 19,
        width: 19,
      ),
      onTap: () {
        Navigator.pop(context);

        if (this.next != null) {
          this.next(context);
        }
      },
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(Provider.of<Store>(context).studentId ?? '点击登录'),
          currentAccountPicture: Image.asset('lib/assets/icons/n.png'),
          accountEmail: Text(Provider.of<Store>(context).username ?? '请先登录'),
          onDetailsPressed: () {
            if (!Provider.of<Store>(context).vefiry) {
              Navigator.pushNamed(context, '/login');
            }
          },
        ),
//        DrawerItem('首页', ICON_INDEX),
        DrawerItem('搜索图书', ICON_SEACH, (context) {
          Navigator.pushNamed(context, '/search');
        }),
        DrawerItem('违章情况', ICON_PAY, (context) {
          this.vefifyLogin(context, '/payment');
        }),
        DrawerItem('借阅历史', ICON_HISTORY, (context) {
          this.vefifyLogin(context, '/history');
        }),
        DrawerItem('帮助与反馈', ICON_HELP, (context) {
          Navigator.pushNamed(context, '/help');
        }),
        DrawerItem('关于', ICON_ABOUT, (context) {
          Navigator.pushNamed(context, '/about');
        })
      ],
      padding: EdgeInsets.zero,
    ));
  }

  void vefifyLogin(BuildContext context, String path) {
    if (Provider.of<Store>(context).vefiry) {
      Navigator.pushNamed(context, path);
    } else {
      Navigator.pushNamed(context, '/login');
    }
  }
}
