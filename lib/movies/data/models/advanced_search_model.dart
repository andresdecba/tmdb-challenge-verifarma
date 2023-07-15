import 'package:tmdb_challenge/movies/data/models/movie_model.dart';

class AdvancedSearchModel {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  AdvancedSearchModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory AdvancedSearchModel.fromJson(Map<String, dynamic> json) => AdvancedSearchModel(
        page: json["page"],
        results: List<MovieModel>.from(json["results"].map((x) => MovieModel.fromJson(x))),
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
