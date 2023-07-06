import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/advanced_movies_search_usecase.dart';

// NOW PLAYING //
final advancedSearchAsyncProvider = StateNotifierProvider<AdvancedSearchAsyncController, AsyncValue<AdvancedMoviesSearch>>((ref) {
  // instanciar caso de uso
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

  late TextEditingController keywordCtlr;
  late TextEditingController fromYearCtlr;
  late TextEditingController toYearCtlr;
  late TextEditingController peopleCtlr;
  late TextEditingController yearCtlr;

  Future<void> getData() async {
    final result = await useCase.call(
      category: '80, 12',
      fromYear: DateTime(2010, 1, 1),
      toYear: DateTime(2015, 12, 31),
      keyWord: 'dark knight, batman',
      people: '525, 3894',
      year: null,
    );

    result.fold(
      (failure) {
        failure.showError();
        //state = AsyncValue.error(failure, StackTrace.current);
      },
      (data) {
        AsyncValue.data(data);
      },
    );
  }

  // Future<void> nextPage() async {
  //   if (currentPage == 0) state = const AsyncValue.loading();

  //   _cancelTimer();
  //   _debounceTimer = Timer(
  //     const Duration(milliseconds: 666),
  //     () async {
  //       currentPage++;

  //       //////////------------
  //       final result = await useCase.call(
  //         category: ,
  //         fromYear: ,
  //         keyWord: ,
  //         people: ,
  //         toYear: ,
  //         year: ,
  //       );
  //       ///////---------
  //       result.fold(
  //         (failure) {
  //           failure.showError();
  //           //state = AsyncValue.error(failure, StackTrace.current);
  //         },
  //         (data) {
  //           if (state.value != null) {
  //             state = AsyncValue.data([...state.value!, ...data]);
  //           } else {
  //             state = AsyncValue.data([...data]);
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  void _cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }
}
