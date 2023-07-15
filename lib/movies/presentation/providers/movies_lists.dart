import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movies_list.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movies_list_usecase.dart';

final moviesList = StateNotifierProvider.autoDispose.family<MoviesListNotifier, AsyncValue<MoviesList>, String>((ref, list) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    list,
  );

  return MoviesListNotifier(useCase: useCase);
});

class MoviesListNotifier extends StateNotifier<AsyncValue<MoviesList>> {
  MoviesListNotifier({
    required this.useCase,
  }) : super(const AsyncValue.loading()) {
    [];
  }

  GetMoviesListUseCase useCase;
  Timer? _debounceTimer;
  Future<void> onPageChanged(int pageIndex) async {
    state = const AsyncValue.loading();
    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 500),
      () async {
        final result = await useCase.call(page: pageIndex);
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
