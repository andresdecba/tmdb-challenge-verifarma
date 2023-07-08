import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/advanced_movies_search.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie_category.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/advanced_movies_search_usecase.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_categories.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_persons.dart';

/// used in [AdvancedSearchPage]
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

  //// OBTENER DATOS ////
  Future<void> getData({
    required String year,
    required String keyword,
    required String toYear,
    required String fromYear,
    required List<int> selectedCategories,
  }) async {
    String? from = fromYear != '' ? DateFormat('yyyy-MM-dd').format(DateTime(int.parse(fromYear), 1, 1)) : '';
    String? to = toYear != '' ? DateFormat('yyyy-MM-dd').format(DateTime(int.parse(toYear), 12, 31)) : '';

    // debouncer
    _cancelTimer();
    _debounceTimer = Timer(
      const Duration(milliseconds: 666),
      () async {
        final result = await useCase.call(
          category: selectedCategories.toString(),
          fromYear: from,
          toYear: to,
          keyWord: keyword,
          people: '3894', //'525, 3894',
          year: year,
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

/// used in [CategoriesList]
final getCategoriesProvider = FutureProvider<List<MovieCategory>>((ref) async {
  final useCase = GetCategoriesUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  List<MovieCategory> value = [];
  var result = await useCase.call();
  result.fold(
    (failure) {
      //AsyncValue.error(failure, StackTrace.current);
      failure.showError();
    },
    (data) {
      //AsyncValue.data(data);
      value = data;
    },
  );
  return value;
});

final selectedCategProvider = StateProvider<List<int>>((ref) {
  return [];
});

/// used in [PersonsList]
final getPersonsProvider = StateNotifierProvider<GetPersonsController, AsyncValue<List<PersonDetails>>>((ref) {
  final GetPersonsUseCase useCase = GetPersonsUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );
  return GetPersonsController(useCase);
});

class GetPersonsController extends StateNotifier<AsyncValue<List<PersonDetails>>> {
  GetPersonsController(this.useCase) : super(const AsyncValue.data([]));
  final GetPersonsUseCase useCase;

  String currentSearchValue = '';

  int currentPage = 1;
  void nextPage() {
    currentPage++;
  }

  Future<void> onDataChange({required String query}) async {
    state = const AsyncValue.loading();

    var result = await useCase.call(query: query, page: currentPage);
    result.fold(
      (failure) {
        failure.showError();
      },
      (data) {
        if (state.value != null) {
          state = AsyncValue.data([...state.value!, ...data]);
        } else {
          state = AsyncValue.data([...data]);
        }
      },
    );
  }
}

final selectedPersonProvider = StateProvider<List<int>>((ref) {
  return [];
});



/*
.watch = observar el estado
ref.watch(productsProvider);

.read = modificar el estado
ref.read(productSortTypeProvider.notifier).state = value!, ó
ref.read(counterProvider.notifier).update((state) => state + 1);

*/

