import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_provider.dart';
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
    ref.read(topRatedProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingWatch = ref.watch(topRatedProvider);

    return MoviesGridView(
      movies: nowPlayingWatch,
      loadNextPage: () {
        ref.read(topRatedProvider.notifier).nextPage();
      },
    );
  }
}
