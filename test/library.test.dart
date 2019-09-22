import 'package:my_lib/crawler/library/library.dart';

const String username = 'B18030407';
const String password = 'B18030407';

void main(List<String> args) async {
  Library library = new Library();
  library
    ..setUsername(username)
    ..setPassword(password);
  var a = await library.login();
  print((await library.getHistory()).value);
}
