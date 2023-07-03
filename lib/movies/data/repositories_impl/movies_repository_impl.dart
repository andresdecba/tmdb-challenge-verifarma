import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/api_network.dart';
import 'package:tmdb_challenge/core/network/failures.dart';
import 'package:tmdb_challenge/movies/domain/data_source/movies_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/repositories/movies_repositoriy.dart';

class MovieRepositoryImpl extends MoviesRepository {
  MovieRepositoryImpl(
    this.datasource,
  );

  final MoviesDatasource datasource;

  @override
  Future<Either<Failure, List<Movie>>> getMoviesList({required int page, required String moviesList}) {
    return ApiNetwork.call(
      () async => datasource.getMovies(
        page: page,
        moviesList: moviesList,
      ),
    );
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies({required String query}) {
    return ApiNetwork.call(
      () async => datasource.searchMovies(query: query),
    );
  }

  @override
  Future<Either<Failure, Movie>> getMovie({required String movieId}) {
    return ApiNetwork.call(
      () async => datasource.getMovie(movieId: movieId),
    );
  }
}
