import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class TopRatedTab extends ConsumerStatefulWidget {
  const TopRatedTab({super.key});
  @override
  TopRatedTabState createState() => TopRatedTabState();
}

class TopRatedTabState extends ConsumerState<TopRatedTab> {
  @override
  void initState() {
    super.initState();
    ref.read(topRatedAsync.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(topRatedAsync);

    return provider.when(
      data: (data) => MoviesGridView(
        movies: data,
        loadNextPage: () {
          ref.read(topRatedAsync.notifier).nextPage();
        },
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
