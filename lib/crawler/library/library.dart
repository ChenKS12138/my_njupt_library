import 'dart:convert' as Convert;
import 'dart:core';
import 'dart:core' as prefix0;

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as Http;
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:my_lib/crawler/library/captcha.dart';

class LoginType {
  static const String STUDENT_ID = 'cert_no';
  static const String CARD_ID = 'bar_no';
  static const String EMAIL = 'email';
}

class Library {
  static const String HOST = '202.119.228.6:8080';
  static const String PROTOCOL = 'http';
  // 验证码
  static const String CAPTCHA =
      '$PROTOCOL://$HOST/reader/captcha.php?0.2226025362345463';
  // 登录
  static const String LOGIN = '$PROTOCOL://$HOST/reader/redr_verify.php';
  // 信息
  static const String INFO = '$PROTOCOL://$HOST/reader/redr_info_rule.php';
  // 已借图书分类
  static const String CLASS_SORT =
      '$PROTOCOL://$HOST/reader/ajax_class_sort.php';
  // 已借阅按月分类
  static const String MONTH_SORT =
      '$PROTOCOL://$HOST/reader/ajax_month_sort.php';

  //已借阅按年分类
  static const String YEAR_SORT = '$PROTOCOL://$HOST/reader/ajax_year_sort.php';
  // 首页
  static const String INDEX = '$PROTOCOL://$HOST/reader/redr_info.php';
  // 借阅历史
  static const String HISTORY = '$PROTOCOL://$HOST/reader/book_hist.php';
  // 违章缴款
  static const String PAYMENT = '$PROTOCOL://$HOST/reader/fine_pec.php';

  final String username;
  final String password;
  final Http.Client instance = new Http.Client();
  final Map<String, String> personalInfo = new Map();
  final Map<String, int> classSort = new Map();
  final Map<String, int> monthSort = new Map();
  final Map<String, int> yearSort = new Map();
  final List<Map<String, String>> history = new List();
  final List<Map<String, String>> payment = new List();

  String loginType;
  String cookie;

  Library(@required this.username, @required this.password, String loginType) {
    if (loginType == null) {
      loginType = LoginType.CARD_ID;
    }
    this.loginType = loginType;
  }

  Future<bool> login() async {
    final String captchaCode = await this.getCaptcha();
    final Map<String, String> data = {
      'number': this.username,
      'passwd': this.password,
      'captcha': captchaCode,
      'select': this.loginType,
      'returnUrl': ''
    };
    Http.Response response = await instance.post(Library.LOGIN,
        body: data, headers: this.getHeader());
    if (response.statusCode == 302) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getCaptcha() async {
    final Http.Response response =
        await instance.get(Library.CAPTCHA, headers: this.getHeader());

    final String cookie = response.headers['set-cookie'];
    this.cookie = cookie.substring(0, cookie.length - 8);

    final Image image = decodeImage(response.bodyBytes);
    final Captcha captcha = new Captcha(image);
    return captcha.toString();
  }

  Map<String, String> getHeader() {
    Map<String, String> header = {
      'Host': Library.HOST,
      'Origin': '$PROTOCOL://$HOST',
      'Referer': Library.LOGIN,
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36',
      'Accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
      'Cache-Control': 'max-age=0',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    if (this.cookie != null) {
      header['cookie'] = cookie;
    }
    return header;
  }

  Future<Map> getInfo() async {
    final Http.Response response =
        await instance.get(Library.INFO, headers: this.getHeader());
    String text = Convert.utf8.decode(response.bodyBytes);
    Document dom = parse(text);
    List<Element> mylibMsg = dom.querySelectorAll('.mylib_msg > a');
    String Msg =
        mylibMsg.fold("", (previous, current) => previous += current.innerHtml);
    RegExp getNum = new RegExp(r'>\d+<');
    var msgMatch = getNum
        .allMatches(Msg)
        .map((item) => item.group(0))
        .map((item) => item.substring(1, item.length - 1))
        .toList();
    this.personalInfo['dueInFive'] = msgMatch[0];
    this.personalInfo['exceedCount'] = msgMatch[1];
    this.personalInfo['orderCount'] = msgMatch[2];
    this.personalInfo['entrustCount'] = msgMatch[3];
    List<Element> tds = dom.querySelectorAll('#mylib_info  td');
    this.personalInfo['name'] =
        tds[1].outerHtml.substring(37, tds[1].outerHtml.length - 5);
    this.personalInfo['studentID'] =
        tds[2].outerHtml.substring(39, tds[2].outerHtml.length - 5);
    this.personalInfo['barCode'] =
        tds[3].outerHtml.substring(38, tds[3].outerHtml.length - 5);
    this.personalInfo['expiryDate'] =
        tds[4].outerHtml.substring(39, tds[4].outerHtml.length - 5);
    this.personalInfo['registDate'] =
        tds[5].outerHtml.substring(39, tds[5].outerHtml.length - 5);
    this.personalInfo['effectiveDate'] =
        tds[6].outerHtml.substring(39, tds[6].outerHtml.length - 5);
    this.personalInfo['maxBorrowCount'] =
        tds[7].outerHtml.substring(41, tds[7].outerHtml.length - 5).trim();
    this.personalInfo['maxOrderCount'] =
        tds[8].outerHtml.substring(42, tds[8].outerHtml.length - 5).trim();
    this.personalInfo['maxEntrustCount'] =
        tds[9].outerHtml.substring(42, tds[9].outerHtml.length - 5).trim();
    this.personalInfo['studentType'] =
        tds[10].outerHtml.substring(39, tds[10].outerHtml.length - 5);
    this.personalInfo['borrowLevel'] =
        tds[11].outerHtml.substring(39, tds[11].outerHtml.length - 5);
    this.personalInfo['accumulatedCount'] =
        tds[12].outerHtml.substring(39, tds[12].outerHtml.length - 5);
    this.personalInfo['violationCount'] =
        tds[13].outerHtml.substring(39, tds[13].outerHtml.length - 5);
    this.personalInfo['arrear'] =
        tds[14].outerHtml.substring(39, tds[14].outerHtml.length - 5);
    this.personalInfo['id'] =
        tds[17].outerHtml.substring(52, tds[17].outerHtml.length - 5);
    this.personalInfo['department'] =
        tds[18].outerHtml.substring(39, tds[18].outerHtml.length - 5);
    this.personalInfo['sex'] =
        tds[21].outerHtml.substring(37, tds[21].outerHtml.length - 5);
    this.personalInfo['guaranteeDeposit'] =
        tds[28].outerHtml.substring(37, tds[28].outerHtml.length - 5);
    this.personalInfo['serviceFee'] =
        tds[29].outerHtml.substring(38, tds[29].outerHtml.length - 5);
    return this.personalInfo;
  }

  Future<Map> getClassSort() async {
    Http.Response response =
        await Http.get(Library.CLASS_SORT, headers: this.getHeader());
    var raw = Convert.json.decode(Convert.utf8.decode(response.bodyBytes));
    for (var item in raw) {
      this.classSort[item['legendText']] = item['y'];
    }
    return this.classSort;
  }

  Future<Map> getMonthSort() async {
    Http.Response response =
        await Http.get(Library.MONTH_SORT, headers: this.getHeader());
    var raw = Convert.json.decode(Convert.utf8.decode(response.bodyBytes));
    for (var item in raw) {
      this.monthSort[(int.parse(item['month']) + 1).toString()] = item['y'];
    }
    return this.monthSort;
  }

  Future<Map> getYearSort() async {
    Http.Response response =
        await Http.get(Library.YEAR_SORT, headers: this.getHeader());
    var raw = Convert.json.decode(Convert.utf8.decode(response.bodyBytes));
    for (var item in raw) {
      this.yearSort[item['label']] = item['y'];
    }
    return this.yearSort;
  }

  Future<String> getRank() async {
    Http.Response response =
        await Http.get(Library.INDEX, headers: this.getHeader());
    Document dom = parse(response.body);
    String rank = dom.querySelector('.Num').innerHtml;
    rank = (int.parse(rank.substring(0, rank.length - 1)) / 100).toString();
    this.personalInfo['rank'] = rank;
    return rank;
  }

  Future<List> getHistory() async {
    Http.Response response = await Http.post(Library.HISTORY,
        body: {'para_string': 'all', 'topage': '1'}, headers: this.getHeader());
    final String text = Convert.utf8.decode(response.bodyBytes);
    Document dom = parse(text);
    List<Element> tds = dom.querySelectorAll('tr');
    for (var value in tds) {
      List<Element> tds = value.querySelectorAll('td');
      if (tds != null) {
        Map<String, String> temp = {
          'id': tds[1].text,
          'name': tds[2].text,
          'author': tds[3].text,
          'borrowDate': tds[4].text,
          'returnDate': tds[5].text,
          'place': tds[6].text
        };
        this.history.add(temp);
      }
    }
    return this.history;
  }

  Future<List> getPayment() async {
    Http.Response response =
        await Http.get(Library.PAYMENT, headers: this.getHeader());
    final String text = Convert.utf8.decode(response.bodyBytes);
    Document dom = parse(text);
    List<Element> trs = dom.querySelectorAll('tr');
    trs = trs.sublist(1);
    for (var value in trs) {
      List<Element> tds = value.querySelectorAll('td');
      if (tds != null) {
        Map<String, String> temp = {
          'id': tds[0].text,
          'boodId': tds[1].text,
          'name': tds[2].text,
          'author': tds[3].text,
          'borrowDate': tds[4].text,
          'returnDate': tds[5].text,
          'place': tds[6].text,
          'expectPayment': tds[7].text,
          'actualPayment': tds[8].text,
          'status': tds[9].text
        };
        this.payment.add(temp);
      }
    }
    return this.payment;
  }
}
