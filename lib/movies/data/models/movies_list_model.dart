import 'package:tmdb_challenge/movies/data/models/movie_model.dart';

class MoviesListModel {
  final DatesListModel? dates;
  final int? page;
  final List<MovieModel>? results;
  final int? totalPages;
  final int? totalResults;

  MoviesListModel({
    this.dates,
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory MoviesListModel.fromJson(Map<String, dynamic> json) => MoviesListModel(
        dates: json["dates"] == null ? null : DatesListModel.fromJson(json["dates"]),
        page: json["page"],
        results: json["results"] == null ? [] : List<MovieModel>.from(json["results"]!.map((x) => MovieModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "dates": dates?.toJson(),
        "page": page,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class DatesListModel {
  final String maximum;
  final String minimum;

  DatesListModel({
    required this.maximum,
    required this.minimum,
  });

  factory DatesListModel.fromJson(Map<String, dynamic> json) => DatesListModel(
        maximum: json["maximum"],
        minimum: json["minimum"],
      );

  Map<String, dynamic> toJson() => {
        "maximum": maximum,
        "minimum": minimum,
      };
}
