import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_challenge/core/network/exceptions.dart';
import 'package:tmdb_challenge/core/network/dio_client.dart';
import 'package:tmdb_challenge/movies/data/mappers/movie_mapper.dart';
import 'package:tmdb_challenge/movies/data/models/advanced_movies_search_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_challenge/movies/data/models/tmdb_movie_model.dart';
import 'package:tmdb_challenge/movies/domain/data_source/movies_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

// CORE -> DOMAIN -> DATA -> USE_CASES -> PRESENTATION
class MoviesDatasourceImpl extends MoviesDatasource {
  // mapper
  final MovieMapper mapper = MovieMapper();

  @override
  Future<List<Movie>> getMovies({required int page, required String moviesList}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/movie/$moviesList',
        queryParameters: {
          'page': page,
        },
      );

      final result = List<Movie>.from(
        dioResponse.data["results"].map(
          (e) => mapper.movieMapper(
            TMDBMovieModel.fromJson(e),
          ),
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<Movie>> searchMovies({required String query}) async {
    if (query.isEmpty) return [];
    final dio = await DioClient.callDio();
    try {
      final dioResponse = await dio.get(
        '/search/movie',
        queryParameters: {
          'query': query.trim(),
        },
      );

      final result = List<Movie>.from(
        dioResponse.data["results"].map(
          (e) => mapper.movieMapper(
            TMDBMovieModel.fromJson(e),
          ),
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<Movie> getMovie({required String movieId}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/movie/$movieId',
      );

      final result = mapper.movieDetailsMapper(
        MovieDetailsModel.fromJson(dioResponse.data),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<AdvancedMoviesSearch> advancedMoviesSearch({
    String? keyWord,
    DateTime? fromYear,
    DateTime? toYear,
    int? year,
    String? people,
    String? category,
  }) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/discover/movie',
        queryParameters: {
          if (keyWord != null) 'with_keywords': keyWord.trim(),
          if (fromYear != null) 'primary_release_date.gte': DateFormat('yyyy-MM-dd').format(fromYear),
          if (toYear != null) 'primary_release_date.lte': DateFormat('yyyy-MM-dd').format(toYear),
          if (people != null) 'with_people': people,
          if (year != null) 'year': year,
          if (category != null) 'genre_ids': category,
        },
      );

      final result = mapper.advancedMoviesSearchMapper(
        AdvancedMoviesSearchModel.fromJson(dioResponse.data),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }
}
