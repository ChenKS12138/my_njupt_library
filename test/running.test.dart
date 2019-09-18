import 'package:my_lib/crawler/running/running.dart';

const String id = 'B18030721';
const String name = '陈凯森';
void main() async {
  Running running = new Running(name, id);
  running.fetchData();
}
