import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
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
    ref.read(upcomingAsync.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(upcomingAsync);

    return provider.when(
      data: (data) => MoviesGridView(
        movies: data,
        loadNextPage: () {
          ref.read(upcomingAsync.notifier).nextPage();
        },
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
