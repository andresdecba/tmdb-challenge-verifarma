import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favs = ref.watch(favoriteProviderAsync);
    final storage = ref.read(storageProvider);
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: customAppbar,
      body: favs.when(
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Text(
                'No tienes favoritos\nguardados aún.',
                style: textStyle.titleLarge!.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                //
                return MovieTile(
                  movie: data[index],
                  onMovieSelected: () {
                    context.pushNamed(
                      AppRoutes.movieDetailsPage,
                      extra: data[index],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
