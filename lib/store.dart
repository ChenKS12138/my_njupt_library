import 'package:flutter/material.dart';
import 'package:my_njupt_library/crawler/library/library.dart';

class Store with ChangeNotifier {
  Library _library = new Library();
  LibraryPersonalInfo _personalInfo;
  LibraryPayment _payment;
  LibraryHistory _history;
  String _rank;

  get vefiry => _library?.verify;
  get library => _library;
  get personalInfo => _personalInfo;
  get username => _personalInfo?.name;
  get studentId => _personalInfo?.studentID;
  get payment => _payment?.value;
  get history => _history?.value;
  get rank => _rank;

  Future<bool> login(String username, String password) async {
    _library
      ..setUsername(username)
      ..setPassword(password);
    bool success = await _library.login();
    if (success) {
      this._personalInfo = await _library.getInfo();
      this._payment = await _library.getPayment();
      this._history = await _library.getHistory();
      print(this._history.value);
      this._rank = await _library.getRank();
    }

    return success;
  }
}
