import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/keyword.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';

abstract class MoviesDatasource {
  //Future<List<Movie>> getMoviesList({required int page, required String moviesList});

  Future<MoviesList> getMoviesList({required int page, required String moviesList});

  Future<List<Movie>> searchMovies({required String query});
  Future<Movie> getMovie({required String movieId});
  Future<AdvancedMoviesSearch> advancedMoviesSearch({
    String? keyWord,
    int? year,
    String? toYear,
    String? fromYear,
    String? persons,
    String? categories,
  });
  Future<List<MovieCategory>> getCategories();
  Future<List<PersonDetails>> getPersons({required String query, required int page});
  Future<List<Keyword>> getKeywords({required String query, required int page});
  Future<List<Movie>> getTrendingMovies({required int page});
}
