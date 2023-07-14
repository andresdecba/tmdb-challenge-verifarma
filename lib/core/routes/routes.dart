import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/login/presentation/pages/login_page.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/pages/advanced_results_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/favorites_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/movie_details_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/advanced_search_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/new_home_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/movies_list.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  // Pages
  static const loginPage = 'loginPage';
  static const movieDetailsPage = 'movieDetailsPage';
  static const favoritesPage = 'favoritesPage';
  static const filterSearchPage = 'filterSearchPage';
  static const newHome = 'newHome';
  static const moviesList = 'moviesList';
  static const advancedResultsPage = 'advancedResultsPage';

  static final appRoutes = GoRouter(
    initialLocation: '/newHome', //'/loginPage', // '/nowPlaying',
    navigatorKey: rootNavigatorKey,
    routes: [
      // routes
      GoRoute(
        path: '/loginPage',
        name: loginPage,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/favoritesPage',
        name: favoritesPage,
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/newHome',
        name: newHome,
        builder: (context, state) => const NewHome(),
      ),
      GoRoute(
        path: '/filterSearchPage',
        name: filterSearchPage,
        builder: (context, state) => const AdvancedSearchPage(),
      ),
      GoRoute(
        path: '/movieDetailsPage',
        name: movieDetailsPage,
        builder: (context, state) {
          return MovieDetailsPage(
            movie: state.extra as Movie,
          );
        },
      ),
      GoRoute(
        path: '/advancedResultsPage',
        name: advancedResultsPage,
        builder: (context, state) => const AdvancedResultsPage(),
      ),

      GoRoute(
        path: '/moviesList',
        name: moviesList,
        builder: (context, state) {
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return MoviesList(
            title: args['title'],
            value: args['list'] as AsyncValue<List<Movie>>, // state.extra as AsyncValue<List<Movie>>,
          );
        },
      ),
    ],
  );
}
