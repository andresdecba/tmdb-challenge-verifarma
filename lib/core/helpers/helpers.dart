import 'package:intl/intl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';

class Helpers {
  // ej 45223 => 45 K
  static String numberToHumanRead(double number) {
    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
      locale: 'en',
    ).format(number);
    return formattedNumber;
  }

  static String stringsListToString(List<String> value) {
    //return value.map((e) => e).toList().toString().replaceAll('[', '').replaceAll(']', '').replaceAll(', ', '');
    return value.join(',').replaceAll(', ', ',');
  }

  static String categoriesListToString(List<dynamic> value) {
    var tmp = value.map((e) => e.id.toString()).toList();
    return tmp.join(',').replaceAll(', ', ',');
  }

  static String categoriesToString({required List<MovieCategory> categories, required List<int> movieCategs}) {
    List<String> lista = [];

    for (var category in categories) {
      for (var mc in movieCategs) {
        if (category.id == mc) {
          lista.add(category.name);
        }
      }
    }

    return lista.join(' ・ ');
  }
}
