import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_movies_list_usecase.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_trending_movies.dart';

// NOW PLAYING //
final nowPlayingAsync = StateNotifierProvider<GetMoviesListAsyncController, AsyncValue<List<Movie>>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'now_playing',
  );
  return GetMoviesListAsyncController(useCase: useCase);
});

// POPULAR //
final popularAsync = StateNotifierProvider<GetMoviesListAsyncController, AsyncValue<List<Movie>>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'popular',
  );
  return GetMoviesListAsyncController(useCase: useCase);
});

// TOP RATED //
final topRatedAsync = StateNotifierProvider<GetMoviesListAsyncController, AsyncValue<List<Movie>>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'top_rated',
  );
  return GetMoviesListAsyncController(useCase: useCase);
});

// UPCOMING //
final upcomingAsync = StateNotifierProvider<GetMoviesListAsyncController, AsyncValue<List<Movie>>>((ref) {
  final useCase = GetMoviesListUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
    'upcoming',
  );
  return GetMoviesListAsyncController(useCase: useCase);
});

// TRENDING //
final trendingAsync = StateNotifierProvider<GetMoviesListAsyncController, AsyncValue<List<Movie>>>((ref) {
  final useCase = GetTrendingMoviesUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );
  return GetMoviesListAsyncController(useCase: useCase);
});

class GetMoviesListAsyncController extends StateNotifier<AsyncValue<List<Movie>>> {
  GetMoviesListAsyncController({
    required this.useCase,
  }) : super(const AsyncValue.loading()) {
    [];
  }

  dynamic useCase;
  int currentPage = 0;
  Timer? _debounceTimer;

  Future<void> nextPage() async {
    if (currentPage == 0) state = const AsyncValue.loading();

    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 666),
      () async {
        currentPage++;
        final result = await useCase.call(page: currentPage);
        result.fold(
          (failure) {
            failure.showError();
            //state = AsyncValue.error(failure, StackTrace.current);
          },
          (data) {
            if (state.value != null) {
              state = AsyncValue.data([...state.value!, ...data]);
            } else {
              state = AsyncValue.data([...data]);
            }
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
