import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/models/advanced_movies_search_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_category_model.dart';
import 'package:tmdb_challenge/movies/data/models/movie_detail_model.dart';
import 'package:tmdb_challenge/movies/data/models/person_details_model.dart';
import 'package:tmdb_challenge/movies/data/models/tmdb_movie_model.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';

class MovieMapper {
  final StorageDatasource _storage = StorageDatasourceImpl();

  Movie movieMapper(TMDBMovieModel movieDB) {
    return Movie(
      id: movieDB.id,
      adult: movieDB.adult ?? false,
      backdropPath: (movieDB.backdropPath != null) ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}' : null,
      genreIds: movieDB.genreIds ?? _noGenreIds,
      originalLanguage: movieDB.originalLanguage ?? '',
      originalTitle: movieDB.originalTitle ?? '',
      overview: movieDB.overview ?? '',
      popularity: movieDB.popularity ?? 0.0,
      posterPath: (movieDB.posterPath != null) ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' : null,
      releaseDate: (movieDB.releaseDate != null) ? DateTime.parse(movieDB.releaseDate!) : null,
      title: movieDB.title ?? '',
      video: movieDB.video ?? false,
      voteAverage: movieDB.voteAverage ?? 0.0,
      voteCount: movieDB.voteCount ?? 0,
      isFavorite: isFavorite(movieDB.id),
    );
  }

  Movie movieDetailsMapper(MovieDetailsModel movieDB) {
    return Movie(
      id: movieDB.id,
      adult: false,
      backdropPath: null,
      genreIds: _noGenreIds,
      originalLanguage: '',
      originalTitle: '',
      overview: movieDB.overview ?? '',
      popularity: 0.0,
      posterPath: (movieDB.posterPath != null) ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}' : null,
      releaseDate: null,
      title: movieDB.title ?? '',
      video: false,
      voteAverage: movieDB.voteAverage ?? 0.0,
      voteCount: 0,
      isFavorite: isFavorite(movieDB.id),
    );
  }

  AdvancedMoviesSearch advancedMoviesSearchMapper(AdvancedMoviesSearchModel value) {
    return AdvancedMoviesSearch(
      page: value.page,
      results: value.results.isNotEmpty ? value.results.map((e) => movieMapper(e)).toList() : [],
      totalPages: value.totalPages,
      totalResults: value.totalResults,
    );
  }

  MovieCategory movieCategoryMapper(CategoryModel value) {
    return MovieCategory(
      id: value.id,
      name: value.name,
    );
  }

  PersonDetails personDetailsMapper(PersonDetailsModel value) {
    return PersonDetails(
      id: value.id,
      knownForDepartment: value.knownForDepartment ?? '',
      name: value.name ?? '',
      profilePath: (value.profilePath != null) ? 'https://image.tmdb.org/t/p/w500${value.profilePath}' : null,
    );
  }

  bool isFavorite(int movieId) {
    bool match = false;
    var list = _storage.getFavorites();
    for (var e in list) {
      if (e == movieId.toString()) {
        match = true;
      }
    }
    return match;
  }
}

const List<int> _noGenreIds = [];
