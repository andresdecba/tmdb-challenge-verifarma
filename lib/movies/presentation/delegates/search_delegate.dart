import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/search_movies_usecase.dart';

class SearchMoviesDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesUseCase useCase;

  SearchMoviesDelegate({
    required this.useCase,
  });

  Future<List<Movie>> _getMovies() async {
    final List<Movie> movies = [];
    final result = await useCase.call(query: query);
    result.fold(
      (failure) {
        failure.showError();
        return;
      },
      (data) {
        movies.addAll(data);
      },
    );
    return movies;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
        animate: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    const List<Movie> init = [];

    return FutureBuilder(
      future: _getMovies(),
      initialData: init,
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, int index) {
            snapshot.data![index].title;
            return ListTile(
              title: Text(snapshot.data![index].title),
              visualDensity: VisualDensity.compact,
            );
          },
        );
      },
    );
  }
}
