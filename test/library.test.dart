import 'package:my_njupt_library/crawler/library/library.dart';

const String username = 'B18030721';
const String password = 'B18030721';

void main(List<String> args) async {
  Library library = new Library();
  library
    ..setUsername(username)
    ..setPassword(password);
  // bool success = await library.login();
  // print(await library.getInfo());
  // print(await library.getPayment());
  // print(await library.getHistory());
  // print(await library.getRank());
  // print(success);
  // LibrarySearch search =await  Library.search(name: 'javascript');
  // print(search);
}
