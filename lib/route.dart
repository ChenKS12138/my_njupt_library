import 'package:flutter/material.dart';

import './views/about.dart';
import './views/help.dart';
import './views/history.dart';
import './views/index.dart';
import './views/login.dart';
import './views/payment.dart';
import './views/search.dart';

Map<String, Widget Function(BuildContext)> route = {
  '/': (context) => new Index(),
  '/search': (context) => new Search(),
  '/payment': (context) => new Payment(),
  '/history': (context) => new History(),
  '/help': (context) => new Help(),
  '/about': (context) => new About(),
  '/login': (context) => new Login()
};
