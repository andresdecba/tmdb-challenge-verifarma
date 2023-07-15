import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

class MoviesGridView extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback? loadNextPage;

  const MoviesGridView({
    super.key,
    required this.movies,
    this.loadNextPage,
  });

  @override
  State<MoviesGridView> createState() => _MoviesGridViewState();
}

class _MoviesGridViewState extends State<MoviesGridView> {
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
    return MasonryGridView.count(
      shrinkWrap: true,
      controller: scrollController,
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        if (index == 1) {
          return Column(
            children: [
              const SizedBox(height: 20),
              MoviePoster(
                posterPath: widget.movies[index].posterPath,
                //height: 150,
                onTap: () => context.pushNamed(
                  AppRoutes.movieDetailsPage,
                  extra: widget.movies[index],
                ),
              ),
            ],
          );
        }
        return MoviePoster(
          posterPath: widget.movies[index].posterPath,
          //height: 150,
          onTap: () => context.pushNamed(
            AppRoutes.movieDetailsPage,
            extra: widget.movies[index],
          ),
        );
      },
    );
  }
}
