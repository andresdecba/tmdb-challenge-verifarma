import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/keyword.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<Movie>>> getMoviesList({required int page, required String moviesList});
  Future<Either<Failure, List<Movie>>> searchMovies({required String query});
  Future<Either<Failure, Movie>> getMovie({required String movieId});
  Future<Either<Failure, AdvancedMoviesSearch>> advancedMoviesSearch({
    String? keyWord,
    String? fromYear,
    String? toYear,
    int? year,
    String? persons,
    String? categories,
  });
  Future<Either<Failure, List<MovieCategory>>> getCategories();
  Future<Either<Failure, List<PersonDetails>>> getPersons({required String query, required int page});
  Future<Either<Failure, List<Keyword>>> getKeywords({required String query, required int page});
}
