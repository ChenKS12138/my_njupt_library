import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:my_lib/crawler/library/image_data.dart';

class Captcha {
  static const int BLACK = 0;
  static const int WHITE = 255;
  static const _split_y = [16, 26];
  static const _split_x = [4, 16, 28, 40, 52];
  static const double MATCH_RATE = 0.98;

  /// 被切割后的图像应为  12*10的图像
  List<int> sourceImage;
  int width;
  int height;

  Captcha(@required Image sourceImage) {
    this.sourceImage =
        Captcha._denoise(Captcha._rgba2Bitmap(sourceImage.getBytes().toList()));
    this.width = sourceImage.width;
    this.height = sourceImage.height;
  }

  static List<int> _denoise(List<int> CaptchaByte) {
    return CaptchaByte.map((item) => item > (WHITE - item) ? WHITE : BLACK)
        .map((item) => item != 0 ? 1 : 0)
        .toList();
  }

  static List<int> _rgba2Bitmap(List<int> rgbaBytes) {
    if (rgbaBytes.length % 4 == 0) {
      const int unitSize = 4;
      final result = new List<int>();
      final length = rgbaBytes.length;
      for (int index = 0; index < length; index += unitSize) {
        final int R = rgbaBytes[index];
        final int G = rgbaBytes[index + 1];
        final int B = rgbaBytes[index + 2];
        final int A = rgbaBytes[index + 3];
        result.add((R + G + B) ~/ 3);
      }
      return result;
    } else {
      return null;
    }
  }

  List<List<int>> _splitImage() {
    if (this.sourceImage.length == this.height * this.width) {
      List<List<int>> matrix = [[], [], [], []];
      for (int i = Captcha._split_y[0]; i < Captcha._split_y[1]; i++) {
        for (int j = 0; j < 4; j++) {
          matrix[j].addAll(this.sourceImage.sublist(
              i * this.width + Captcha._split_x[j],
              i * this.width + Captcha._split_x[j + 1]));
        }
      }
      return matrix;
    } else {
      return null;
    }
  }

  static bool match(List<int> source, List<int> target) {
    if (source.length == target.length) {
      var a = 123;
      int matchCount = 0;
      int length = source.length;
      for (int i = 0; i < length; i++) {
        if (source[i] == target[i]) matchCount++;
      }
      return matchCount / length > Captcha.MATCH_RATE ? true : false;
    } else {
      return false;
    }
  }

  static List2Char(List<int> source) {
    final List<String> keys = SOURCE.keys.toList();
    final int length = keys.length;
    for (int i = 0; i < length; i++) {
      if (Captcha.match(source, SOURCE[keys[i]])) return keys[i];
    }
    return null;
  }

  String toString() {
    return this._splitImage().map(Captcha.List2Char).join('');
  }
}
