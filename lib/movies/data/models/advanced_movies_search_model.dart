import 'package:tmdb_challenge/movies/data/models/tmdb_movie_model.dart';

class AdvancedMoviesSearchModel {
  final int page;
  final List<TMDBMovieModel> results;
  final int totalPages;
  final int totalResults;

  AdvancedMoviesSearchModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory AdvancedMoviesSearchModel.fromJson(Map<String, dynamic> json) => AdvancedMoviesSearchModel(
        page: json["page"],
        results: List<TMDBMovieModel>.from(json["results"].map((x) => TMDBMovieModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x)),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
