import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_lib/store.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  bool showLoading;
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: ModalProgressHUD(
        child: Center(
          child: Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            width: 400,
            height: 400,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.text,
                  autofocus: false,
                  decoration: new InputDecoration(
                    hintText: '用户名',
                    contentPadding:
                        new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  onChanged: (value) {
                    this.username = value;
                  },
                ),
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  decoration: new InputDecoration(
                    hintText: '密码',
                    contentPadding:
                        new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  onChanged: (value) {
                    this.password = value;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  child: Text(
                    '登录',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  color: Colors.blue,
                  onPressed: () async {
                    this.setState(() {
                      this.showLoading = true;
                    });
                    bool ojbk = await Provider.of<Store>(context)
                        .login(this.username, this.password);
                    this.setState(() {
                      this.showLoading = false;
                    });
                    if (ojbk) {
                      Navigator.pop(context);
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Text('账号密码有误');
                          });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        inAsyncCall: this.showLoading,
      ),
    );
  }

  @override
  void initState() {
    this.setState(() {
      this.showLoading = false;
    });
  }
}
