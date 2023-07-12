import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/delegates/search_delegate.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/providers/search_delegate_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/bottom_navigation.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/horizontal_listview.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: SvgPicture.asset(
          'assets/tmdb_logo.svg',
          height: 15,
        ),
        titleSpacing: 20,
        centerTitle: true,
      ),
      //extendBodyBehindAppBar: true,
      bottomNavigationBar: const MyBottomNavigation(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _SearchBar(ref: ref),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // NOW PLAYING
                  _MoviesHorizontalList(
                    list: ref.watch(nowPlayingAsync),
                    nextPage: () => ref.read(nowPlayingAsync.notifier).nextPage(),
                    title: 'En cartelera',
                  ),
                  // POPULAR
                  _MoviesHorizontalList(
                    list: ref.watch(popularAsync),
                    nextPage: () => ref.read(popularAsync.notifier).nextPage(),
                    title: 'Más populares',
                  ),
                  // TOP RATED

                  _MoviesHorizontalList(
                    list: ref.watch(topRatedAsync),
                    nextPage: () => ref.read(topRatedAsync.notifier).nextPage(),
                    title: 'Mejores ranqueadas',
                  ),
                  // UPCOMING

                  _MoviesHorizontalList(
                    list: ref.watch(upcomingAsync),
                    nextPage: () => ref.read(upcomingAsync.notifier).nextPage(),
                    title: 'Próximos estrenos',
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

class _MoviesHorizontalList extends ConsumerWidget {
  const _MoviesHorizontalList({
    required this.list,
    required this.nextPage,
    required this.title,
  });

  final AsyncValue<List<Movie>> list;
  final VoidCallback nextPage;
  final String title;

  @override
  Widget build(BuildContext context, ref) {
    //final moviesList = ref.watch(nowPlayingAsync);
    final textStyles = Theme.of(context).textTheme;

    return list.when(
      data: (data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
      loading: () => const Center(
        child: CircularProgressIndicator(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
      ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: const Icon(Icons.search),
                ),
              ),
            ),
            IconButton(
              onPressed: () => context.goNamed(AppRoutes.filterSearchPage),
              icon: const Icon(Icons.filter_list),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              onPressed: () {
                ref.read(favoriteProviderAsync.notifier).getFavorites();
                context.goNamed(AppRoutes.favoritesPage);
              },
              icon: const Icon(Icons.favorite),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }
}
