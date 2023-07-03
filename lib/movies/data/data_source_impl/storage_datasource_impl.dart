// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';

const String favoritesBox = 'favoritesBox';

class StorageDatasourceImpl extends StorageDatasource {
  final _storage = Hive.box<String>(favoritesBox);

  @override
  void saveFavorite(String value) {
    _storage.add(value);
  }

  @override
  void removeFavorite(int value) {
    _storage.delete(value);
  }

  @override
  List<String> getFavorites() {
    return _storage.values.toList();
  }
}


/*
class StorageDatasourceImpl extends StorageDatasource {
  StorageDatasourceImpl({
    required this.storage,
  });

  final SharedPreferences storage;

  @override
  Future<List<String>?> getFavorites() async {
    return storage.getStringList(_favorites);
  }

  @override
  Future<bool> removeFavorites() async {
    return await storage.remove(_favorites);
  }

  @override
  Future<bool> saveFavorites(List<String> value) async {
    return await storage.setStringList(_favorites, value);
  }
}


*/