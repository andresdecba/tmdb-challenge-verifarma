import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_storage.g.dart';

/// TO GENERATE THE REGISTER ADAPTER RUN:
/// 1° este:            flutter packages pub run build_runner build
/// si sale mal, este:  flutter packages pub run build_runner build --delete-conflicting-outputs

@HiveType(typeId: 1)
class FavoriteStorage {
  FavoriteStorage({
    required this.moviesIds,
  });

  @HiveField(0)
  final List<String> moviesIds;
}
