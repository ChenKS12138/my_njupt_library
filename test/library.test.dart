import 'package:my_lib/crawler/library/library.dart';

const String username = 'B18030721';
const String password = 'B18030721';

void main(List<String> args) async {
  Library library = new Library(username, password, LoginType.CARD_ID);
  await library.login();
  await library.getInfo();
}
