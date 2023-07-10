import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/advanced_movies_search_usecase.dart';

// BUSCAR EN DB PROVIDER

final advancedSearchAsyncProvider = StateNotifierProvider<AdvancedSearchAsyncController, AsyncValue<AdvancedMoviesSearch>>((ref) {
  final useCase = AdvancedMoviesSearchUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  return AdvancedSearchAsyncController(useCase: useCase);
});

class AdvancedSearchAsyncController extends StateNotifier<AsyncValue<AdvancedMoviesSearch>> {
  AdvancedSearchAsyncController({
    required this.useCase,
  }) : super(const AsyncValue.loading());

  AdvancedMoviesSearchUseCase useCase;
  int currentPage = 0;
  Timer? _debounceTimer;

  Future<void> getData({
    required String keyword,
    required String categories,
    required String persons,
    required String year,
    required String fromYear,
    required String toYear,
  }) async {
    String? parsedFrom = fromYear != '' ? DateFormat('yyyy-MM-dd').format(DateTime(int.parse(fromYear), 1, 1)) : '';
    String? parsedTo = toYear != '' ? DateFormat('yyyy-MM-dd').format(DateTime(int.parse(toYear), 12, 31)) : '';

    //debouncer
    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 666),
      () async {
        final result = await useCase.call(
          categories: categories,
          persons: persons,
          keyWord: keyword,
          year: year,
          fromYear: parsedFrom,
          toYear: parsedTo,
        );
        result.fold(
          (failure) {
            failure.showError();
            //state = AsyncValue.error(failure, StackTrace.current);
          },
          (data) {
            AsyncValue.data(data);
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
