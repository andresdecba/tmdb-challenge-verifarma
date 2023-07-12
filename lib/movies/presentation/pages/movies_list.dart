import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class MoviesList extends ConsumerWidget {
  const MoviesList({
    required this.value,
    required this.title,
    super.key,
  });

  final AsyncValue<List<Movie>> value;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: customAppbar,
      body: value.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                title,
                style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MoviesGridView(
                    movies: data,
                    loadNextPage: () {
                      ref.read(nowPlayingAsync.notifier).nextPage();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
