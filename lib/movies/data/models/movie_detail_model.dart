class MovieDetailsModel {
  int id;
  String? title;
  String? posterPath;
  String? overview;
  double? voteAverage;

  MovieDetailsModel({
    required this.id,
    this.overview,
    this.posterPath,
    this.title,
    this.voteAverage,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) => MovieDetailsModel(
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        title: json["title"],
        voteAverage: json["vote_average"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "title": title,
        "vote_average": voteAverage,
      };
}
