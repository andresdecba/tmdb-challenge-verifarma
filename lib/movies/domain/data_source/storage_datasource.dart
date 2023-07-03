abstract class StorageDatasource {
  void saveFavorite(String value);
  void removeFavorite(String value);
  List<String> getFavorites();
}
