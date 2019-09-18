import 'package:html/dom.dart';
import 'package:http/http.dart' as Http;
import 'package:meta/meta.dart';

class Running {
  static const String TIMEZONE = 'Asia/Shanghai';
  static const String BASE_URL = 'http://zccx.tyb.njupt.edu.cn';

  final String name;
  final String student_id;

  Running(@required this.name, @required this.student_id);
  void fetchData() async {
    if (this.name != null && this.student_id != null) {
      final Map<String, String> data = {
        'number': this.student_id,
        'name': this.name
      };
      Http.Response response =
          await Http.post('${Running.BASE_URL}/student', body: data);
      Document document = Document.html(response.body);
      var a = document.getElementsByTagName('tbody');
    } else {
      return null;
    }
  }
}
