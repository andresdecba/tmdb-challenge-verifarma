import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class MoviesListPage extends ConsumerStatefulWidget {
  const MoviesListPage({
    required this.title,
    required this.moviesList,
    super.key,
  });

  final String title;
  final String moviesList;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoviesListPageState();
}

class _MoviesListPageState extends ConsumerState<MoviesListPage> {
  late PageController pageCtlr;

  @override
  void initState() {
    super.initState();
    pageCtlr = PageController();
    ref.read(moviesList(widget.moviesList).notifier).onPageChanged(1);
    //ref.watch(moviesList(widget.moviesList)).whenData((value) => totalPages = value.totalPages);
  }

  @override
  void dispose() {
    super.dispose();
    pageCtlr.dispose();
  }

  int currentPage = 1;
  int totalPages = 20;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    final movies = ref.watch(moviesList(widget.moviesList));
    final moviesNotifier = ref.read(moviesList(widget.moviesList).notifier);

    return Scaffold(
      appBar: customAppbar,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// HEADER ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_left_sharp,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.title,
                        style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // movies.when(
                      //   data: (data) => Text(
                      //   'Página $currentPage de ${data.totalPages}',
                      //   style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                      // ),
                      //   error: (error, stackTrace) => Text('error'),
                      //   loading: () {},
                      // ),

                      Text(
                        'Página $currentPage de $totalPages',
                        style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: PageView.builder(
                controller: pageCtlr,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,

                // CHANGE
                onPageChanged: (value) {
                  moviesNotifier.onPageChanged(value + 1);
                  setState(() {
                    currentPage = value + 1;
                  });
                },
                // BUILD
                itemBuilder: (context, index) {
                  return movies.when(
                    data: (data) {
                      totalPages = data.totalPages;

                      return MoviesGridView(
                        movies: data.results,
                        loadNextPage: () {},
                      );
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
