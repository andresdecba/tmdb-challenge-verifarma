import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

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
              _MoviePoster(movie: widget.movies[index]),
            ],
          );
        }

        return _MoviePoster(movie: widget.movies[index]);
      },
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({required this.movie});

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: () => context.pushNamed(
          AppRoutes.movieDetailsPage,
          extra: movie,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: FadeInImage(
            height: 180,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/bottle-loader.gif'),
            image: NetworkImage(movie.posterPath),
          ),
        ),
      ),
    );
  }
}
