import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/favorite_storage.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteStorageAdapter());
  await Hive.openBox<String>(favoritesBox);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.appRoutes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
