import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

class HorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const HorizontalListView({
    super.key,
    required this.movies,
    this.loadNextPage,
  });

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (widget.loadNextPage == null) return;
      if ((scrollController.position.pixels + 100) >= scrollController.position.maxScrollExtent) {
        widget.loadNextPage!();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: widget.movies.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        controller: scrollController,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 7),
            child: MoviePoster(
              posterPath: widget.movies[index].posterPath,
              height: 150,
              onTap: () => context.pushNamed(
                AppRoutes.movieDetailsPage,
                extra: widget.movies[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
