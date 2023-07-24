import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_preview_providers.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/horizontal_listview.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/bottom_navigation.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: customAppbar,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const BottomNavigation(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // SEARCH BAR
            SafeArea(
              child: _SearchBar(ref: ref),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // SLIDER
                  _CarouselSlider(),
                  const SizedBox(height: 20),

                  // NOW PLAYING
                  _MoviesHorizontalList(
                    list: ref.watch(moviesListPreview(nowPlaying)),
                    title: 'En cartelera',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesListPage,
                      extra: {"moviesList": nowPlaying, "title": 'En cartelera'},
                    ),
                  ),

                  // UPCOMING
                  _MoviesHorizontalList(
                    list: ref.watch(moviesListPreview(upcoming)),
                    title: 'Próximos estrenos',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesListPage,
                      extra: {"moviesList": upcoming, "title": 'Próximos estrenos'},
                    ),
                  ),

                  // TOP RATED
                  _MoviesHorizontalList(
                    list: ref.watch(moviesListPreview(topRated)),
                    title: 'Mejores ranqueadas',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesListPage,
                      extra: {"moviesList": topRated, "title": 'Mejores ranqueadas'},
                    ),
                  ),

                  // POPULAR
                  _MoviesHorizontalList(
                    list: ref.watch(moviesListPreview(popular)),
                    title: 'Más populares',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesListPage,
                      extra: {"moviesList": popular, "title": 'Más populares'},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarouselSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final moviesList = ref.watch(tendingMoviesPreview);
    double height = MediaQuery.of(context).size.height * 0.35;
    final textStyles = Theme.of(context).textTheme;

    return moviesList.when(
      data: (data) {
        var items = data!.map((e) {
          var idx = data.indexOf(e) + 1;
          return MoviePoster(
            posterPath: e.posterPath,
            visibleWidget: true,
            onTap: () => context.pushNamed(
              AppRoutes.movieDetailsPage,
              extra: e,
            ),
            widget: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'TOP\n',
                children: [
                  TextSpan(
                    text: idx.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        return Column(
          children: [
            // title
            Text(
              'Top tendencias hoy',
              style: textStyles.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.75),
              ),
            ),
            const SizedBox(height: 15),
            // bottom gradient //
            DecoratedBox(
              position: DecorationPosition.background,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3],
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
              child: CarouselSlider(
                items: items,
                options: CarouselOptions(
                  height: height,
                  aspectRatio: 2 / 3,
                  viewportFraction: 0.55,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {},
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) => Text('error $error'),
      loading: () => SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _MoviesHorizontalList extends ConsumerWidget {
  const _MoviesHorizontalList({
    required this.list,
    required this.title,
    required this.navigate,
  });

  final AsyncValue<MoviesList?> list;
  final String title;
  final VoidCallback navigate;

  @override
  Widget build(BuildContext context, ref) {
    //final moviesList = ref.watch(nowPlayingAsync);
    final textStyles = Theme.of(context).textTheme;

    return list.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => navigate(),
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            // movies
            HorizontalListView(
              movies: data!.results,
              onNavigate: () => navigate(),
            ),
            const SizedBox(height: 20)
          ],
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.searchMovieByTitlePage),
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.25),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Text(
                        'Buscar en TMDB',
                        style: textStyles.bodySmall!.copyWith(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => context.pushNamed(AppRoutes.filterSearchPage),
              icon: const Icon(Icons.filter_list),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
