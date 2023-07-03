import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    //ref.read(favoritesProvider.notifier).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final favoriteProvider = ref.watch(favoritesProvider.notifier);
    const List<Movie> initial = [];

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
      body: FutureBuilder(
        future: favoriteProvider.getFavorites(),
        initialData: initial,
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          // 1
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // 2
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            }
            if (snapshot.hasData) {
              // PELIS //
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mis Favoritos',
                        style: textStyles.titleLarge,
                      ),
                      const Divider(
                        height: 20,
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ListView.builder(
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          var item = snapshot.data![index];

                          return MovieTile(
                            movie: item,
                            onMovieSelected: () => context.pushNamed(
                              AppRoutes.movieDetailsPage,
                              extra: item,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          // 3
          return Text(
            'State: ${snapshot.connectionState}',
            style: const TextStyle(color: Colors.white),
          );
        },
      ),
    );
  }
}
