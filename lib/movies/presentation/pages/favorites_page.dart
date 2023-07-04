import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

/*
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final favoriteController = ref.watch(favoritesProvider.notifier);
    final favoriteState = ref.watch(favoritesProvider);
    final seeeeState = ref.watch(seeeeeeeeeee);

    return Scaffold(
      body: seeeeState.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return MovieTile(
                movie: data[index],
                //onMovieSelected: () {},
                onMovieSelected: () {
                  print('/-/-/ ahora si que sí !');
                  // context.pushNamed(
                  //   AppRoutes.movieDetailsPage,
                  //   extra: data[index],
                  // );
                },
              );
            },
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),

      // FutureBuilder(
      //   future: favoriteController.getFavorites(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     return ListView.builder(
      //       itemCount: favoriteState.length,
      //       shrinkWrap: true,
      //       physics: const NeverScrollableScrollPhysics(),
      //       itemBuilder: (BuildContext context, int index) {
      //         return GestureDetector(
      //           onTap: () {
      //             //favoriteState.remove(favoriteState[index]); // TODO
      //             print('pleaaaaseeeee');
      //           },
      //           child: MovieTile(
      //             movie: favoriteState[index],
      //             onMovieSelected: () {},
      //             // onMovieSelected: () => context.pushNamed(
      //             //   AppRoutes.movieDetailsPage,
      //             //   extra: favoriteState[index],
      //             // ),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
*/

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seeeeState = ref.watch(seeeeeeeeeee);
    final seeeeState2 = ref.read(seeeeeeeeeee.notifier);

    final estoooo = ref.watch(esto);

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
      body: seeeeState.when(
        data: (data) {
          return ListView.builder(
            itemCount: estoooo.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return MovieTile(
                movie: estoooo[index],
                //onMovieSelected: () {},
                onMovieSelected: () {
                  print('/-/-/ ahora si que sí !');

                  ref.read(esto).remove(estoooo[index]);

                  //ref.read(esto.notifier).state.remove(data[index]);
                  // context.pushNamed(
                  //   AppRoutes.movieDetailsPage,
                  //   extra: data[index],
                  // );
                },
              );
            },
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
