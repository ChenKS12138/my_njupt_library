import 'dart:convert' as Convert;

import 'package:http/http.dart' as Http;

String utf8decode(raw) {
  return Convert.utf8.decode(raw);
}

jsonDecode(raw) {
  return Convert.json.decode(raw);
}

String generateParams(Map<String, String> source) {
  String result = "";
  source.forEach((key, value) {
    result += '$key=$value&';
  });
  result = result.substring(0, result.length - 1);
  return result;
}

class BaseCrawler {
  Http.Client instance = new Http.Client();
  Map<String, String> _header = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.132 Safari/537.36',
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
    'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
    'Cache-Control': 'max-age=0',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  Map<String, String> getHeader() {
    return this._header;
  }

  final Exception NEED_LOGIN = new Exception(['you need login']);

  void setHeaderCookie(value) {
    this._header['cookie'] = value;
  }

  void setHeaderHost(value) {
    this._header['Host'] = value;
  }

  void setHeaderOrigin(value) {
    this._header['Origin'] = value;
  }

  void setHeaderReferer(value) {
    this._header['Referer'] = value;
  }
}
