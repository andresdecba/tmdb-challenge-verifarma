import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

class AdvancedMoviesSearch {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  AdvancedMoviesSearch({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });
}
