import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tmdb_challenge/core/helpers/helpers.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_categories.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  const MovieDetailsPage({required this.movie, super.key});

  final Movie movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends ConsumerState<MovieDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   //backgroundColor: Colors.black.withOpacity(0.5),
      // ),
      //extendBody: true,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _Image(movie: widget.movie),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen',
                    style: textStyles.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview,
                    style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Casting',
                    style: textStyles.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview,
                    style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
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
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // TITLE
                          Text(
                            movie.title,
                            style: textStyles.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
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
                              child: CircularProgressIndicator(),
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

class MovieDetailsPageA extends ConsumerStatefulWidget {
  const MovieDetailsPageA({
    super.key,
    required this.movie,
  });
  final Movie movie;

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieDetailsPageA> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: widget.movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _MovieDetails(movie: widget.movie),
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}

// DESCRIPCION //
class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            movie.title,
            style: textStyles.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(
            movie.overview,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star),
                Text(movie.voteAverage.toString()),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerStatefulWidget {
  final Movie movie;
  const _CustomSliverAppBar({
    required this.movie,
  });

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends ConsumerState<_CustomSliverAppBar> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.movie.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        background: Stack(
          children: [
            // image //
            SizedBox.expand(
              child: widget.movie.posterPath != null
                  ? Image.network(
                      widget.movie.posterPath!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) return const SizedBox();
                        return FadeIn(child: child);
                      },
                    )
                  : Image.asset(
                      'assets/no-image.png',
                      fit: BoxFit.cover,
                    ),
            ),

            // top gradient //
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.25],
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // bottom gradient //
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.8, 1.0],
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
              ),
            ),

            // favorite icon //
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: const EdgeInsets.all(20),
                  onPressed: () {}, //() => _addRemoveFav(),
                  icon: _isFav
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 30,
                        )
                      : const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
