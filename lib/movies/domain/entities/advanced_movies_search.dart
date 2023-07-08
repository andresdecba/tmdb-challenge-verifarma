import 'package:equatable/equatable.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

class AdvancedMoviesSearch extends Equatable {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const AdvancedMoviesSearch({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [page, results];
}
