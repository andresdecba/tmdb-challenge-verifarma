import 'package:equatable/equatable.dart';

import 'movie.dart';

class MoviesList extends Equatable {
  final DatesList? dates;
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  const MoviesList({
    this.dates,
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [page, results];
}

class DatesList extends Equatable {
  final String maximum;
  final String minimum;

  const DatesList({
    required this.maximum,
    required this.minimum,
  });

  @override
  List<Object?> get props => [maximum, minimum];
}
