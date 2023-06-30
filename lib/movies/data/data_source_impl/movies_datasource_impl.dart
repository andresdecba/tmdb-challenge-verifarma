import 'package:dio/dio.dart';
import 'package:tmdb_challenge/core/network/exceptions.dart';
import 'package:tmdb_challenge/movies/data/models/db_response.dart';
import 'package:tmdb_challenge/movies/domain/data_source/movies_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// CORE -> DOMAIN -> DATA -> USE_CASES -> PRESENTATION

class MoviesDatasourceImpl extends MoviesDatasource {
  // config prettyDio
  Future<Dio> _getDio() async {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
          'api_key': 'c5113d97db256e4fe3b80577006c26df',
          'language': 'es-MX',
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
    return dio;
  }

  @override
  Future<List<Movie>> getMovies({required int page, required String moviesList}) async {
    final dio = await _getDio();
    try {
      final dioResponse = await dio.get(
        '/movie/$moviesList', //'/movie/now_playing',
        queryParameters: {
          'page': page,
        },
      );
      final dbResponse = DbResponse.fromJson(dioResponse.data);
      final List<Movie> movies = dbResponse.results
          .where((moviedb) => moviedb.posterPath != 'no-poster') //
          .map((e) => e) //
          .toList();
      return movies;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<Movie>> searchMovies({required String query}) async {
    if (query.isEmpty) return [];
    final dio = await _getDio();
    try {
      final dioResponse = await dio.get(
        '/search/movie',
        queryParameters: {
          'query': query,
        },
      );
      final dbResponse = DbResponse.fromJson(dioResponse.data);
      final List<Movie> movies = dbResponse.results
          .where((moviedb) => moviedb.posterPath != 'no-poster') //
          .map((e) => e) //
          .toList();
      return movies;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }
}
