import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/advanced_seach.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class AdvancedResultsPage extends ConsumerWidget {
  const AdvancedResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(advancedSearchAsyncProvider);

    return Scaffold(
      appBar: customAppbar,
      body: provider.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error $error'),
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${data.totalResults.toString()} resultados, ${data.totalPages.toString()} paginas'),
                const Divider(color: Colors.white),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      itemCount: data.results.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return MovieTile(
                          movie: data.results[index],
                          height: 90,
                          onMovieSelected: () {
                            context.pushNamed(
                              AppRoutes.movieDetailsPage,
                              extra: data.results[index],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
