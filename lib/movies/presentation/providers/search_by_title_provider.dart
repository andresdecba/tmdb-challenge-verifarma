import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/search_movies_by_title_usecase.dart';

final searchByTitleProvider = StateNotifierProvider<SearchByTtileNotifier, AsyncValue<MoviesList>>((ref) {
  final useCase = SearchMoviesByTitleUseCase(MovieRepositoryImpl(MoviesDatasourceImpl()));

  return SearchByTtileNotifier(useCase: useCase);
});

class SearchByTtileNotifier extends StateNotifier<AsyncValue<MoviesList>> {
  SearchByTtileNotifier({
    required this.useCase,
  }) : super(const AsyncValue.loading());

  SearchMoviesByTitleUseCase useCase;
  Timer? _debounceTimer;

  Future<void> onQueryChanged(String query, int pageIndex) async {
    state = const AsyncValue.loading();
    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 333),
      () async {
        final result = await useCase.call(query: query, page: pageIndex);
        result.fold(
          (failure) {
            failure.showError();
          },
          (data) {
            state = AsyncValue.data(data);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  void _cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }
}
