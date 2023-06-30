import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class UpcomingTab extends ConsumerStatefulWidget {
  const UpcomingTab({super.key});
  @override
  UpcomingTabState createState() => UpcomingTabState();
}

class UpcomingTabState extends ConsumerState<UpcomingTab> {
  @override
  void initState() {
    super.initState();
    ref.read(upcomingProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingWatch = ref.watch(upcomingProvider);

    return MoviesGridView(
      movies: nowPlayingWatch,
      loadNextPage: () {
        ref.read(upcomingProvider.notifier).nextPage();
      },
    );
  }
}
