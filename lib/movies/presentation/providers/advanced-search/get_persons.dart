import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_persons_usecases.dart';

/// BUSCAR PERSONAS PROVIDER ///
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

final selectedPersonProvider = StateProvider<List<PersonDetails>>((ref) {
  return [];
});
