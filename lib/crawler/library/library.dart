import 'dart:core';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as Http;
import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:my_lib/crawler/core/BaseCrawler.dart';
import 'package:my_lib/crawler/library/captcha.dart';
import 'package:my_lib/crawler/library/type.dart';

export 'type.dart';

class Library extends BaseCrawler {
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
  // 搜索书目
  static const String SEARCH = '$PROTOCOL://$HOST/opac/openlink.php';
  // 推荐书目
  static const String RECOMMEND = '$PROTOCOL://$HOST/top/top_lend.php';
  //书目详情
  static const String DETAIL = '$PROTOCOL://$HOST/opac/item.php';

  final String _username;
  final String _password;
  bool verify = false;

  String _loginType;

  Library(
      @required this._username, @required this._password, String loginType) {
    if (loginType == null) {
      loginType = LoginType.CARD_ID;
    }
    this._loginType = loginType;

    this
      ..setHeaderHost(Library.HOST)
      ..setHeaderOrigin('$PROTOCOL://$HOST')
      ..setHeaderReferer(Library.LOGIN);
  }

  Future<bool> login() async {
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
      List<Element> tds = dom.querySelectorAll('tr');
      List<LibraryHistoryItem> historyResult = new List();
      if (tds.isNotEmpty) {
        for (var value in tds) {
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
            tds[0].text,
            tds[1].text,
            tds[2].text,
            tds[3].text,
            tds[4].text,
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
    List<Element> dds = dom.querySelectorAll('.booklist > dd');
    return new LibraryDetail(dds[1].text, dds[2].text, dds[3].text, dds[4].text,
        dds[5].text, dds[6].text, dds[9].text, dds[11].text, dds[12].text);
  }
}
