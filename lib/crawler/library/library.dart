/**
 * author: ChenKS
 * date: 2019-09-20
 * usage: create a instance of Library and get personal information
 *  `or use static methods to search ,get recommendation and get detail information
 */

import 'dart:core';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as Http;
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:my_njupt_library/crawler/core/BaseCrawler.dart';
import 'package:my_njupt_library/crawler/library/captcha.dart';
import 'package:my_njupt_library/crawler/library/type.dart';

export 'type.dart';

class Library extends BaseCrawler {
  static const String HOST = '202.119.228.6:8080';
  static const String PROTOCOL = 'http';
  static const String BASE_URL = 'http://202.119.228.6:8080';
  // 验证码
  static const String CAPTCHA =
      '$BASE_URL/reader/captcha.php?0.2226025362345463';
  // 登录
  static const String LOGIN = '$BASE_URL/reader/redr_verify.php';
  // 信息
  static const String INFO = '$BASE_URL/reader/redr_info_rule.php';
  // 已借图书分类
  static const String CLASS_SORT =
      '$BASE_URL/reader/ajax_class_sort.php';
  // 已借阅按月分类
  static const String MONTH_SORT =
      '$BASE_URL/reader/ajax_month_sort.php';

  //已借阅按年分类
  static const String YEAR_SORT = '$BASE_URL/reader/ajax_year_sort.php';
  // 首页
  static const String INDEX = '$BASE_URL/reader/redr_info.php';
  // 借阅历史
  static const String HISTORY = '$BASE_URL/reader/book_hist.php';
  // 违章缴款
  static const String PAYMENT = '$BASE_URL/reader/fine_pec.php';
  // 搜索书目
  static const String SEARCH = '$BASE_URL/opac/openlink.php';
  // 推荐书目
  static const String RECOMMEND = '$BASE_URL/top/top_lend.php';
  //书目详情
  static const String DETAIL = '$BASE_URL/opac/item.php';

  String _username;
  String _password;
  bool verify = false;

  String _loginType;

  Library(
      {String username,
      String password,
      String loginType: LoginType.STUDENT_ID}) {
    if (username != null) {
      this._username = username;
      this.setUsername(username);
    }
    if (password != null) {
      this._password = password;
      this.setPassword(password);
    }
    this._loginType = loginType;
    this
      ..setHeaderHost(Library.HOST)
      ..setHeaderOrigin(BASE_URL)
      ..setHeaderReferer(Library.LOGIN);
  }

  void setUsername(String username) {
    this._username = username;
  }

  void setPassword(String password) {
    this._password = password;
  }

  Future<bool> login() async {
    if (this.verify) {
      return true;
    } else {
      try {
        final String captchaCode = await this._getCaptcha();
        final Map<String, String> data = {
          'number': this._username,
          'passwd': this._password,
          'captcha': captchaCode,
          'select': this._loginType,
          'returnUrl': ''
        };
        Http.Response response = await instance.post(Library.LOGIN,
            body: data, headers: this.getHeader());
        if (response.statusCode == 302) {
          this.verify = true;
          return true;
        } else {
          this.verify = false;
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }

  Future<String> _getCaptcha() async {
    final Http.Response response =
        await instance.get(Library.CAPTCHA, headers: this.getHeader());

    final String cookie = response.headers['set-cookie'];
    this.setHeaderCookie(cookie.substring(0, cookie.length - 8));

    final Image image = decodeImage(response.bodyBytes);
    final Captcha captcha = new Captcha(image);
    return captcha.toString();
  }

  Future<Map<String, int>> getClassSort() async {
    if (this.verify) {
      Http.Response response =
          await Http.get(Library.CLASS_SORT, headers: this.getHeader());
      var raw = jsonDecode(utf8decode(response.bodyBytes));
      if (raw != null) {
        Map<String, int> classSort = new Map();
        for (var item in raw) {
          classSort[item['legendText']] = item['y'];
        }
        return classSort;
      } else {
        return null;
      }
    } else {
      throw NEED_LOGIN;
    }
  }

  Future<Map<String, int>> getMonthSort() async {
    if (this.verify) {
      Http.Response response =
          await Http.get(Library.MONTH_SORT, headers: this.getHeader());
      var raw = jsonDecode(utf8decode(response.bodyBytes));
      if (raw != null) {
        Map<String, int> monthSort = new Map();
        for (var item in raw) {
          monthSort[(int.parse(item['month']) + 1).toString()] = item['y'];
        }
        return monthSort;
      } else {
        return null;
      }
    } else {
      throw NEED_LOGIN;
    }
  }

  Future<Map<String, int>> getYearSort() async {
    if (this.verify) {
      Http.Response response =
          await Http.get(Library.YEAR_SORT, headers: this.getHeader());
      var raw = jsonDecode(utf8decode(response.bodyBytes));
      if (raw != null) {
        Map<String, int> yearSort = new Map();
        for (var item in raw) {
          yearSort[item['label']] = item['y'];
        }
        return yearSort;
      } else {
        return null;
      }
    } else {
      throw NEED_LOGIN;
    }
  }

  Future<String> getRank() async {
    if (this.verify) {
      Http.Response response =
          await Http.get(Library.INDEX, headers: this.getHeader());
      Document dom = parse(response.body);
      String rank = dom.querySelector('.Num').innerHtml;
      rank = (int.parse(rank.substring(0, rank.length - 1)) / 100).toString();
      return rank;
    } else {
      throw NEED_LOGIN;
    }
  }

  Future<LibraryHistory> getHistory() async {
    if (this.verify) {
      Http.Response response = await Http.post(Library.HISTORY,
          body: {'para_string': 'all', 'topage': '1'},
          headers: this.getHeader());
      final String text = utf8decode(response.bodyBytes);
      Document dom = parse(text);
      List<Element> trs = dom.querySelectorAll('tr');
      List<LibraryHistoryItem> historyResult = new List();
      if (trs != null && trs.length > 1) {
        trs = trs.sublist(1).toList();
        for (var value in trs) {
          List<Element> tds = value.querySelectorAll('td');
          if (tds != null) {
            LibraryHistoryItem temp = new LibraryHistoryItem(
                tds[1].text,
                tds[2].text,
                tds[3].text,
                tds[4].text,
                tds[5].text,
                tds[6].text);
            historyResult.add(temp);
          }
        }
        return new LibraryHistory(historyResult);
      } else {
        return null;
      }
    } else {
      throw NEED_LOGIN;
    }
  }

  Future<LibraryPayment> getPayment() async {
    if (this.verify) {
      Http.Response response =
          await Http.get(Library.PAYMENT, headers: this.getHeader());
      final String text = utf8decode(response.bodyBytes);
      Document dom = parse(text);
      List<Element> trs = dom.querySelectorAll('tr');
      if (trs.isNotEmpty) {
        List<LibraryPaymentItem> paymentResult = new List();
        trs = trs.sublist(1);
        for (var value in trs) {
          List<Element> tds = value.querySelectorAll('td');
          if (tds != null) {
            LibraryPaymentItem temp = new LibraryPaymentItem(
                tds[0].text.trim(),
                tds[1].text.trim(),
                tds[2].text.trim(),
                tds[3].text.trim(),
                tds[4].text.trim(),
                tds[5].text.trim(),
                tds[6].text.trim(),
                tds[7].text.trim(),
                tds[8].text.trim(),
                tds[9].text.trim());
            paymentResult.add(temp);
          }
        }
        return new LibraryPayment(paymentResult);
      } else {
        return null;
      }
    } else {
      throw NEED_LOGIN;
    }
  }

  Future getInfo() async {
    if (this.verify) {
      final Http.Response response =
          await instance.get(Library.INFO, headers: this.getHeader());
      String text = utf8decode(response.bodyBytes);
      Document dom = parse(text);
      List<Element> mylibMsg = dom.querySelectorAll('.mylib_msg > a');
      String Msg = mylibMsg.fold(
          "", (previous, current) => previous += current.innerHtml);
      RegExp getNum = new RegExp(r'>\d+<');
      List msgMatch = getNum
          .allMatches(Msg)
          .map((item) => item.group(0))
          .map((item) => item.substring(1, item.length - 1))
          .toList();
      List<Element> tds = dom.querySelectorAll('#mylib_info  td');
      return new LibraryPersonalInfo(
          msgMatch[0],
          msgMatch[1],
          msgMatch[2],
          msgMatch[3],
          tds[1].outerHtml.substring(37, tds[1].outerHtml.length - 5),
          tds[2].outerHtml.substring(39, tds[2].outerHtml.length - 5),
          tds[3].outerHtml.substring(38, tds[3].outerHtml.length - 5),
          tds[4].outerHtml.substring(39, tds[4].outerHtml.length - 5),
          tds[5].outerHtml.substring(39, tds[5].outerHtml.length - 5),
          tds[6].outerHtml.substring(39, tds[6].outerHtml.length - 5),
          tds[7].outerHtml.substring(41, tds[7].outerHtml.length - 5).trim(),
          tds[9].outerHtml.substring(42, tds[9].outerHtml.length - 5).trim(),
          tds[10].outerHtml.substring(39, tds[10].outerHtml.length - 5),
          tds[11].outerHtml.substring(39, tds[11].outerHtml.length - 5),
          tds[12].outerHtml.substring(39, tds[12].outerHtml.length - 5),
          tds[13].outerHtml.substring(39, tds[13].outerHtml.length - 5),
          tds[14].outerHtml.substring(39, tds[14].outerHtml.length - 5),
          tds[17].outerHtml.substring(52, tds[17].outerHtml.length - 5),
          tds[18].outerHtml.substring(39, tds[18].outerHtml.length - 5),
          tds[21].outerHtml.substring(37, tds[21].outerHtml.length - 5),
          tds[28].outerHtml.substring(37, tds[28].outerHtml.length - 5),
          tds[29].outerHtml.substring(38, tds[29].outerHtml.length - 5));
    } else {
      throw NEED_LOGIN;
    }
  }

  static Future<LibrarySearch> search(
      {@required String name,
      String strSearchType: 'title',
      String match_flag: 'forward',
      String historyCount: '1',
      String doctype: 'ALL',
      String with_ebook: 'on',
      String displaypg: '30',
      String showmode: 'list',
      String sort: 'CATA_DATE',
      String orderby: 'desc',
      String dept: 'ALL'}) async {
    final Map<String, String> data = {
      'strSearchType': strSearchType,
      'match_flag': match_flag,
      'historyCount': historyCount,
      'strText': name,
      'doctype': doctype,
      'with_ebook': with_ebook,
      'displaypg': displaypg,
      'showmode': showmode,
      'sort': sort,
      'orderby': orderby,
      'dept': dept
    };
    Http.Response response =
        await Http.get("${Library.SEARCH}?${generateParams(data)}");
    Document dom = parse(utf8decode(response.bodyBytes));
    List<Element> lis = dom.querySelectorAll('.book_list_info');
    List<LibrarySearchItem> searchResult = new List();

    for (var value in lis) {
      LibrarySearchItem temp = new LibrarySearchItem(
          value.querySelector('h3 a').text.split('\.')[1],
          value.querySelector('h3 span').text,
          value
              .querySelector('p')
              .innerHtml
              .split('<br>')[1]
              .split('</span>')[1]
              .toString(),
          value
              .querySelector('p')
              .innerHtml
              .split('<br>')[2]
              .split('&nbsp;')[0]
              .trim(),
          value.querySelector('a').attributes['href'].split('=')[1]);
      searchResult.add(temp);
    }
    final int allCount =
        int.parse(dom.querySelector('.book_article strong').text);
    final int pageCount =
        int.parse(dom.querySelectorAll('.pagination font')[1].text);

    return new LibrarySearch(searchResult, allCount, pageCount,
        int.parse(historyCount), int.parse(displaypg));
  }

  static Future<LibraryRecommend> recommend() async {
    Http.Response response = await Http.get('${Library.RECOMMEND}?cls_no=ALL');
    Document dom = parse(utf8decode(response.bodyBytes));
    List<Element> trs = dom.querySelectorAll('tr');
    List<LibraryRecommendItem> recommentResult = new List();
    trs = trs.sublist(1);
    if (trs.isNotEmpty) {
      for (var value in trs) {
        var tds = value.querySelectorAll('td');
        LibraryRecommendItem temp = new LibraryRecommendItem(
            tds[1].text,
            tds[2].text,
            tds[3].text,
            tds[4].text,
            tds[0].text,
            tds[5].text,
            tds[6].text,
            value.querySelector('a').attributes['href'].split('=')[1]);
        recommentResult.add(temp);
      }
      return new LibraryRecommend(recommentResult);
    } else {
      return null;
    }
  }

  static Future<LibraryDetail> detail(@required String marc_no) async {
    Http.Response response =
        await Http.get('$DETAIL?${generateParams({'marc_no': marc_no})}');
    Document dom = parse(utf8decode(response.bodyBytes));
    String href =
        dom.querySelector('#tabs1').querySelectorAll('a')[1].attributes['href'];
    Http.Response response2 = await Http.get('$BASE_URL/opac/$href');

    Document dom2 = parse(utf8decode(response2.bodyBytes));
    List<Element> lis = dom2.querySelectorAll('li');
    Map<String, String> temp = new Map();
    for (var item in lis) {
      final String text = item.text;
      String value = text.contains('|a ') ? text.split('|a ')[1] : text;
      value = value.contains('|') ? value.split('|')[0] : value;
      switch (text.substring(0, 3)) {
        case '010':
          temp['callNumber'] = value;
          break;
        case '210':
          temp['press'] = value;
          break;
        case '215':
          temp['size'] = value;
          break;
        case '200':
          temp['name'] = value;
          break;
        case '701':
          temp['author'] = value;
          break;
        case '330':
          temp['summary'] = value;
          break;
      }
    }
    return new LibraryDetail(temp['press'], temp['callNumber'], temp['size'],
        temp['name'], temp['author'], temp['summary']);
  }
}
