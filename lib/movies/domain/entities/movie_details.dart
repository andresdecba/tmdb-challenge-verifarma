import 'package:equatable/equatable.dart';

class MovieDetails extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;

  const MovieDetails({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
    required this.voteAverage,
  });

  @override
  List<Object?> get props => [id, title];

  @override
  String toString() {
    return 'title: $title, id: $id';
  }
}
