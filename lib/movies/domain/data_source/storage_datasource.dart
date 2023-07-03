abstract class StorageDatasource {
  void saveFavorite(String value);
  void removeFavorite(int value);
  List<String> getFavorites();
}
