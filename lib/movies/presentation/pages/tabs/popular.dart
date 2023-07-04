import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class PopularTab extends ConsumerStatefulWidget {
  const PopularTab({super.key});
  @override
  PopularTabState createState() => PopularTabState();
}

class PopularTabState extends ConsumerState<PopularTab> {
  @override
  void initState() {
    super.initState();
    ref.read(popularAsync.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(popularAsync);

    return provider.when(
      data: (data) => MoviesGridView(
        movies: data,
        loadNextPage: () {
          ref.read(popularAsync.notifier).nextPage();
        },
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
