import 'package:dio/dio.dart';
import 'package:tmdb_challenge/core/network/exceptions.dart';
import 'package:tmdb_challenge/core/network/dio_client.dart';
import 'package:tmdb_challenge/movies/data/mappers/movie_details_mapper.dart';
import 'package:tmdb_challenge/movies/data/mappers/movie_mapper.dart';
import 'package:tmdb_challenge/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_challenge/movies/data/models/tmdb_movie_model.dart';
import 'package:tmdb_challenge/movies/domain/data_source/movies_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_details.dart';

// CORE -> DOMAIN -> DATA -> USE_CASES -> PRESENTATION
class MoviesDatasourceImpl extends MoviesDatasource {
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
          (e) => MovieMapper.movieMapper(
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
          (e) => MovieMapper.movieMapper(
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

      final result = MovieMapper.movieDetailsMapper(
        MovieDetailsModel.fromJson(dioResponse.data),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }
}
