import 'dart:core';
import 'dart:io';

import 'package:http/http.dart';
import 'package:image/image.dart';
import 'package:my_lib/crawler/library/captcha.dart';

const String Path = r'd:\test.png';
void main(List<String> args) async {
  Response response = await get(
      'http://202.119.228.6:8080/reader/captcha.php?0.2226025362345463');
  Image captchaImage = decodeImage(response.bodyBytes.toList());
  Captcha captcha = new Captcha(captchaImage);
  print(captcha);
  File file = new File(Path);
//  file.writeAsBytesSync(response.bodyBytes);
  print(response.headers);
}
