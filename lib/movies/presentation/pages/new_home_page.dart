import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/delegates/search_delegate.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/providers/search_delegate_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/horizontal_listview.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/new_bottom_navigation.dart';

class NewHome extends ConsumerStatefulWidget {
  const NewHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewHomeState();
}

class _NewHomeState extends ConsumerState<NewHome> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingAsync.notifier).nextPage();
    ref.read(popularAsync.notifier).nextPage();
    ref.read(topRatedAsync.notifier).nextPage();
    ref.read(upcomingAsync.notifier).nextPage();
    ref.read(trendingAsync.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    //final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: customAppbar,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const NewBottomNavigation(),
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
                    list: ref.watch(nowPlayingAsync),
                    nextPage: () => ref.read(nowPlayingAsync.notifier).nextPage(),
                    title: 'En cartelera',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesList,
                      extra: {"list": ref.read(nowPlayingAsync), "title": 'En cartelera'},
                    ),
                  ),

                  // POPULAR
                  _MoviesHorizontalList(
                    list: ref.watch(popularAsync),
                    nextPage: () => ref.read(popularAsync.notifier).nextPage(),
                    title: 'Más populares',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesList,
                      extra: {"list": ref.read(popularAsync), "title": 'Más populares'},
                    ),
                  ),

                  // TOP RATED
                  _MoviesHorizontalList(
                    list: ref.watch(topRatedAsync),
                    nextPage: () => ref.read(topRatedAsync.notifier).nextPage(),
                    title: 'Mejores ranqueadas',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesList,
                      extra: {"list": ref.read(topRatedAsync), "title": 'Mejores ranqueadas'},
                    ),
                  ),

                  // UPCOMING
                  _MoviesHorizontalList(
                    list: ref.watch(upcomingAsync),
                    nextPage: () => ref.read(upcomingAsync.notifier).nextPage(),
                    title: 'Próximos estrenos',
                    navigate: () => context.pushNamed(
                      AppRoutes.moviesList,
                      extra: {"list": ref.read(upcomingAsync), "title": 'Próximos estrenos'},
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
    final moviesList = ref.watch(trendingAsync);
    double height = MediaQuery.of(context).size.height * 0.35;
    final textStyles = Theme.of(context).textTheme;

    return moviesList.when(
      data: (data) {
        var items = data.map((e) {
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
    required this.nextPage,
    required this.title,
    required this.navigate,
  });

  final AsyncValue<List<Movie>> list;
  final VoidCallback nextPage;
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
            HorizontalListView(
              movies: data,
              loadNextPage: () => nextPage(),
            ),
            const SizedBox(
              height: 20,
            )
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      width: double.infinity,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // SEARCH MOVIES //
                  final searchMovies = ref.read(searchMoviesProvider);
                  showSearch(
                    context: context,
                    delegate: SearchMoviesDelegate(useCase: searchMovies),
                  ).then((value) {
                    if (value == null) return;
                    context.pushNamed(AppRoutes.movieDetailsPage, extra: value);
                  });
                },
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.20),
                  ),
                  child: const Icon(Icons.search),
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
