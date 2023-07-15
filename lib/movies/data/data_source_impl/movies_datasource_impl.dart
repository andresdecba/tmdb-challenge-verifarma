import 'package:dio/dio.dart';

import 'package:tmdb_challenge/core/network/exceptions.dart';
import 'package:tmdb_challenge/core/network/dio_client.dart';
import 'package:tmdb_challenge/movies/data/mappers/movie_mapper.dart';
import 'package:tmdb_challenge/movies/data/models/advanced_search_model.dart';
import 'package:tmdb_challenge/movies/data/models/keyword_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_category_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_challenge/movies/data/models/movies_list_model.dart';
import 'package:tmdb_challenge/movies/data/models/person_details_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_model.dart';
import 'package:tmdb_challenge/movies/domain/data_source/movies_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/keyword.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';

// CORE -> DOMAIN -> DATA -> USE_CASES -> PRESENTATION

const String nowPlaying = 'now_playing';
const String popular = 'popular';
const String topRated = 'top_rated';
const String upcoming = 'upcoming';

class MoviesDatasourceImpl extends MoviesDatasource {
  // mapper
  final MovieMapper mapper = MovieMapper();

  @override
  Future<MoviesList> getMoviesList({required int page, required String moviesList}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/movie/$moviesList',
        queryParameters: {
          'page': page,
        },
      );

      final result = mapper.movieListMaper(
        MoviesListModel.fromJson(dioResponse.data),
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
            MovieModel.fromJson(e),
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
    int? year,
    String? toYear,
    String? fromYear,
    String? persons,
    String? categories,
  }) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/discover/movie',
        queryParameters: {
          if (keyWord != null) 'with_keywords': keyWord.trim(),
          if (fromYear != null) 'primary_release_date.gte': fromYear.trim(),
          if (toYear != null) 'primary_release_date.lte': toYear.trim(),
          if (persons != null) 'with_people': persons.trim(),
          if (year != null) 'year': year,
          if (categories != null) 'with_genres': categories.trim(),
        },
      );

      final result = mapper.advancedMoviesSearchMapper(
        AdvancedSearchModel.fromJson(dioResponse.data),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<MovieCategory>> getCategories() async {
    final dio = await DioClient.callDio();
    try {
      final dioResponse = await dio.get(
        '/genre/movie/list',
      );
      final result = List<MovieCategory>.from(
        dioResponse.data['genres'].map(
          (e) {
            return mapper.movieCategoryMapper(
              CategoryModel.fromJson(e),
            );
          },
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<PersonDetails>> getPersons({required String query, required int page}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/search/person',
        queryParameters: {
          'query': query.trim(),
          'page': page,
        },
      );

      final result = List<PersonDetails>.from(
        dioResponse.data['results'].map(
          (e) {
            return mapper.personDetailsMapper(PersonDetailsModel.fromJson(e));
          },
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<Keyword>> getKeywords({required String query, required int page}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/search/keyword',
        queryParameters: {
          'query': query.trim(),
          'page': page,
        },
      );

      final result = List<Keyword>.from(
        dioResponse.data['results'].map(
          (e) {
            return mapper.keywordMapper(KeywordModel.fromJson(e));
          },
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }

  @override
  Future<List<Movie>> getTrendingMovies({required int page}) async {
    final dio = await DioClient.callDio();

    try {
      final dioResponse = await dio.get(
        '/trending/movie/day',
        queryParameters: {
          'page': page,
        },
      );

      final result = List<Movie>.from(
        dioResponse.data["results"].map(
          (e) => mapper.movieMapper(
            MovieModel.fromJson(e),
          ),
        ),
      );

      return result;
    } on DioException catch (error) {
      throw ExceptionUtils.getExceptionFromStatusCode(error);
    }
  }
}
