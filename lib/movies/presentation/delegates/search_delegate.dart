import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/search_movies_usecase.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

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
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
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
        final data = snapshot.data ?? [];

        // LIST VIEW BDR //
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return _SearchItem(
              movie: data[index],
              onMovieSelected: () {
                close(context, data);
                EasyDebounce.cancel('search-debounce');
              },
            );
          },
        );
      },
    );
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
        EasyDebounce.cancel('search-debounce');
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

class _SearchItem extends StatelessWidget {
  final Movie movie;
  final VoidCallback onMovieSelected;

  const _SearchItem({super.key, required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        onMovieSelected();
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              MoviePoster(
                posterPath: movie.posterPath,
                height: 120,
              ),

              const SizedBox(width: 20),

              // Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
