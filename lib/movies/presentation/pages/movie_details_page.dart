import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tmdb_challenge/core/helpers/helpers.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_categories.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/custom_buttom.dart';

class MovieDetailsPage extends ConsumerWidget {
  const MovieDetailsPage({required this.movie, super.key});
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // image
            _Image(movie: movie),

            // options
            _Options(
              movie: movie,
            ),

            // info
            _MovieInfo(
              movie: movie,
            )
          ],
        ),
      ),
    );
  }
}

class _MovieInfo extends StatelessWidget {
  const _MovieInfo({
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sinopsis',
            style: textStyles.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            movie.overview,
            style: textStyles.titleSmall!.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            'Lanzamiento',
            style: textStyles.titleSmall,
          ),
          const SizedBox(height: 10),
          if (movie.releaseDate != null)
            Text(
              DateFormat('dd-MM-yyyy').format(movie.releaseDate!),
              style: textStyles.bodySmall!.copyWith(color: Colors.grey),
            ),
          const SizedBox(height: 20),
          Text(
            'Casting',
            style: textStyles.titleSmall,
          ),
          const SizedBox(height: 10),
          Text(
            'Tom Cruise, Miles Teller, Jennifer Connelly, Jon Hamm, Glen Powell, Tom Cruise, Miles Teller, Jennifer Connelly, Jon Hamm, Glen Powell,',
            style: textStyles.bodySmall!.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _Options extends ConsumerStatefulWidget {
  const _Options({required this.movie});
  final Movie movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __OptionsState();
}

class __OptionsState extends ConsumerState<_Options> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    final favs = ref.read(storageProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    widget.movie.isFavorite ? favs.removeFavorite(widget.movie.id.toString()) : favs.saveFavorite(widget.movie.id.toString());
                    widget.movie.isFavorite ? widget.movie.isFavorite = false : widget.movie.isFavorite = true;
                    ref.refresh(favoriteProviderAsync.notifier).getFavorites();
                  });
                },
                icon: Icon(widget.movie.isFavorite ? Icons.favorite : Icons.favorite_border_rounded),
              ),
              Text(
                'Favorito',
                style: textStyle,
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined),
              ),
              Text(
                'Calificar',
                style: textStyle,
              ),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share),
              ),
              Text(
                'Comartir',
                style: textStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Image extends ConsumerWidget {
  const _Image({
    required this.movie,
  });
  final Movie movie;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final categs = ref.watch(getCategoriesProvider);
    return movie.posterPath != null
        ? SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                children: [
                  // IMAGE
                  DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0, 1],
                        tileMode: TileMode.clamp,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset('assets/bottle-loader.gif'),
                    ),
                  ),
                  // BACK BUTTON
                  SafeArea(
                    minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomButtom(
                        icon: Icons.arrow_back,
                        onTap: () => context.pop(),
                      ),
                    ),
                  ),
                  // DATA - INFO
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // WATCH TRAILER
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow),
                                Text('Ver trailer'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // TITLE
                          Text(
                            movie.title,
                            style: (movie.title.length < 41)
                                ? textStyles.headlineMedium!.copyWith(fontWeight: FontWeight.bold)
                                : textStyles.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // CATEGORIES
                          categs.when(
                            data: (data) {
                              var values = Helpers.categoriesToString(
                                categories: data,
                                movieCategs: movie.genreIds,
                              );
                              return Text(
                                values,
                                style: textStyles.bodySmall,
                                textAlign: TextAlign.center,
                              );
                            },
                            error: (error, stackTrace) => const Text('error'),
                            loading: () => const Center(
                              child: Text('. . .'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // RATE
                          RatingBar.readOnly(
                            size: 25,
                            alignment: Alignment.center,
                            filledIcon: Icons.star,
                            emptyIcon: Icons.star_border,
                            isHalfAllowed: true,
                            halfFilledIcon: Icons.star_half,
                            initialRating: (movie.voteAverage / 2),
                            maxRating: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: FadeInImage(
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/bottle-loader.gif'),
                image: AssetImage('assets/no-image.png'),
              ),
            ),
          );
  }
}
