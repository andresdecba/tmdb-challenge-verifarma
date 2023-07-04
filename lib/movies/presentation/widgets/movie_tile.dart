import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback onMovieSelected;

  const MovieTile({
    super.key,
    required this.movie,
    required this.onMovieSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        onMovieSelected();
      },
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              MoviePoster(
                posterPath: movie.posterPath,
                height: 120,
              ),

              const SizedBox(width: 10),

              // Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.overview,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
