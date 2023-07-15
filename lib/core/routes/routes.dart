import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/login/presentation/pages/login_page.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/presentation/pages/advanced_results_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/favorites_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/movie_details_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/advanced_search_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/home_page.dart';
import 'package:tmdb_challenge/movies/presentation/pages/movies_list_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRoutes {
  // Pages
  static const loginPage = 'loginPage';
  static const movieDetailsPage = 'movieDetailsPage';
  static const favoritesPage = 'favoritesPage';
  static const filterSearchPage = 'filterSearchPage';
  static const homePage = 'homePage';
  static const moviesListPage = 'moviesListPage';
  static const advancedResultsPage = 'advancedResultsPage';

  static final appRoutes = GoRouter(
    initialLocation: '/homePage', //'/loginPage',
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
        path: '/homePage',
        name: homePage,
        builder: (context, state) => const HomePage(),
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
        path: '/moviesListPage',
        name: moviesListPage,
        builder: (context, state) {
          Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return MoviesListPage(
            title: args['title'],
            moviesList: args['moviesList'],
          );
        },
      ),
    ],
  );
}
