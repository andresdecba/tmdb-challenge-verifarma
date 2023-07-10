import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/movies_datasource_impl.dart';
import 'package:tmdb_challenge/movies/data/repositories_impl/movies_repository_impl.dart';
import 'package:tmdb_challenge/movies/domain/entities/keyword.dart';
import 'package:tmdb_challenge/movies/domain/use_cases/get_keywords_usecase.dart';

// OBTENER CATEGORIAS PROVIDER
final getKeywordsProvider = StateNotifierProvider<GetKeywordsController, AsyncValue<List<Keyword>>>((ref) {
  final GetKeywordsUseCase useCase = GetKeywordsUseCase(
    MovieRepositoryImpl(MoviesDatasourceImpl()),
  );

  return GetKeywordsController(useCase);
});

class GetKeywordsController extends StateNotifier<AsyncValue<List<Keyword>>> {
  GetKeywordsController(this.useCase) : super(const AsyncValue.data([]));
  final GetKeywordsUseCase useCase;

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

final selectedKewordsProvider = StateProvider<List<Keyword>>((ref) {
  return [];
});
