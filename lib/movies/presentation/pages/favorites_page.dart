import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final provider = ref.watch(favoriteProviderAsync);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: SvgPicture.asset(
          'assets/tmdb_logo.svg',
          height: 15,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            context.goNamed(AppRoutes.homePage);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: provider.when(
        data: (data) {
          // return MoviesGridView(
          //   movies: data,
          //   loadNextPage: () {},
          // );
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
                    //ref.read(favoriteProviderAsync.notifier).remove(data[index]);
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
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
