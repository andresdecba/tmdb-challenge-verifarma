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
    ref.read(popularProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingWatch = ref.watch(popularProvider);

    return MoviesGridView(
      movies: nowPlayingWatch,
      loadNextPage: () {
        ref.read(popularProvider.notifier).nextPage();
      },
    );
  }
}
