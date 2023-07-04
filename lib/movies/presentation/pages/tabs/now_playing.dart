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
    ref.read(nowPlayingAsync.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlaying = ref.watch(nowPlayingAsync);

    return nowPlaying.when(
      data: (data) => MoviesGridView(
        movies: data,
        loadNextPage: () {
          ref.read(nowPlayingAsync.notifier).nextPage();
        },
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
