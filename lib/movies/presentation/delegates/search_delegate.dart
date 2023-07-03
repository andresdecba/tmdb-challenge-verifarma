import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/search_movies_usecase.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class SearchMoviesDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesUseCase useCase;

  SearchMoviesDelegate({
    required this.useCase,
  });

  final StreamController<List<Movie>> _debouncedMovies = StreamController.broadcast();
  final StreamController<bool> _isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;
  final List<Movie> init = [];

  // necesitamos hacer un stream builder debido al debounce
  /// ya que de interntar construir la lista directamente en el [buildSuggestions]
  // la misma nunca se construye por que la demora del debounce

  void _onSearchChanged() async {
    _isLoadingStream.add(true);
    // debounce y llamar
    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 666),
      () async {
        final result = await useCase.call(query: query);
        result.fold(
          (failure) {
            failure.showError();
            return;
          },
          (data) {
            _debouncedMovies.add(data);
          },
        );
        print(':::: _onSearchChanged ::::');
      },
    );
    _isLoadingStream.add(false);
  }

  Widget _createSearchItemsList() {
    // STREAM BDR //
    return StreamBuilder(
      initialData: init,
      stream: _debouncedMovies.stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final List<Movie> data = snapshot.data ?? [];

        if (data.isEmpty) {
          return _NoResultsItem(
            child: Text(
              'Sin resultados.',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
            ),
          );
        } else {
          // LIST VIEW BDR //
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return MovieTile(
                movie: data[index],
                onMovieSelected: () {
                  close(
                    context,
                    data[index],
                  );
                  _cancelTimer();
                },
              );
            },
          );
        }
      },
    );
  }

  void _cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }

  // clear text button
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: _isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.refresh_rounded)),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
          );
        },
      ),
    ];
  }

  // page back button
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        _cancelTimer();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // build list when press enter
  @override
  Widget buildResults(BuildContext context) {
    return _createSearchItemsList();
  }

  // build results when searching
  // this method is fires every time we press a character
  @override
  Widget buildSuggestions(BuildContext context) {
    print(':::: buildSuggestions ::::');
    _onSearchChanged();
    return _createSearchItemsList();
  }
}

class _NoResultsItem extends StatelessWidget {
  const _NoResultsItem({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: double.infinity,
      alignment: Alignment.center,
      child: child,
    );
  }
}
