import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends ConsumerState<FavoritesPage> {
  late Future<List<Movie>> _value;

  @override
  void initState() {
    super.initState();
    //ref.read(favoritesProvider.notifier).saveFavorite('697843');
    //https://api.themoviedb.org/3/movie/697843
    _value = ref.read(favoritesProvider.notifier).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    //final favoriteProvider = ref.read(favoritesProvider.notifier).getFavorites();
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
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: _value,
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
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return MoviesGridView(
                          movies: snapshot.data!,
                        );
                      },
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
          ],
        ),
      ),
    );
  }
}
