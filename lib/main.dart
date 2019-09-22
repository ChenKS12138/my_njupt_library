import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'route.dart';
import 'store.dart';

void main() {
  runApp(ChangeNotifierProvider<Store>.value(
    child: MyApp(),
    value: Store(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: route,
    );
  }
}
