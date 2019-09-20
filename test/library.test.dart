import 'package:my_lib/crawler/library/library.dart';

const String username = 'B18030407';
const String password = 'B18030407';

void main(List<String> args) async {
  Library library = new Library(username, password, LoginType.CARD_ID);
  await library.login();
  var a = await Library.search(name: 'javascript', historyCount: '2');
  print(a);
}
