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

  final String username;
  final String password;
  final Http.Client instance = new Http.Client();
  final Map<String, String> personalInfo = new Map();

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
//    String text = Convert.utf8.decode(response.bodyBytes);
  }

  Future<String> getCaptcha() async {
    final Http.Response response =
        await instance.get(Library.CAPTCHA, headers: this.getHeader());

    final String cookie = response.headers['set-cookie'];
    this.cookie = cookie.substring(0, cookie.length - 8);

//    print('captcha');
//    print(response.headers);
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
    RegExp getValue = new RegExp(r'[^>]+<$');
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
}