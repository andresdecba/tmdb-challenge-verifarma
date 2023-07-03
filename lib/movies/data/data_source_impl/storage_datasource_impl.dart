import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';

const String favoritesBox = 'favoritesBox';

class StorageDatasourceImpl extends StorageDatasource {
  final _storage = Hive.box<String>(favoritesBox);

  @override
  void saveFavorite(String value) {
    _storage.put(value, value);
  }

  @override
  void removeFavorite(String value) {
    _storage.delete(value);
  }

  @override
  List<String> getFavorites() {
    return _storage.values.toList();
  }
}
