import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/delegates/search_delegate.dart';
import 'package:tmdb_challenge/movies/presentation/providers/seach_movies_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/bottom_navigation.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: SvgPicture.asset(
          'assets/tmdb_logo.svg',
          height: 15,
        ),
        actions: [
          IconButton(
            onPressed: () {
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
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => context.goNamed(AppRoutes.favoritesPage),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const MyBottomNavigation(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: child,
      ),
    );
  }
}
