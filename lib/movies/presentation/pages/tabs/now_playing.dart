import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class NowPlayingTab extends ConsumerStatefulWidget {
  const NowPlayingTab({super.key});
  @override
  NowPlayingTabState createState() => NowPlayingTabState();
}

class NowPlayingTabState extends ConsumerState<NowPlayingTab> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingWatch = ref.watch(nowPlayingProvider);

    return MoviesGridView(
      movies: nowPlayingWatch,
      loadNextPage: () {
        ref.read(nowPlayingProvider.notifier).nextPage();
      },
    );
  }
}
