import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tmdb_challenge/movies/data/data_source_impl/storage_datasource_impl.dart';
import 'package:tmdb_challenge/movies/domain/data_source/storage_datasource.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_lists_providers.dart';
import 'package:collection/collection.dart';

class MovieDetailsPage extends ConsumerStatefulWidget {
  const MovieDetailsPage({
    super.key,
    required this.movie,
  });
  final Movie movie;

  @override
  MovieScreenState createState() => MovieScreenState();
}

class MovieScreenState extends ConsumerState<MovieDetailsPage> {
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
          Text(
            movie.title,
            style: textStyles.titleLarge,
          ),
          const SizedBox(height: 20),
          Text(
            movie.overview,
            overflow: TextOverflow.clip,
          ),
          const SizedBox(height: 50),
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
  late StorageDatasource _storage;

  @override
  void initState() {
    super.initState();
    _isFav = widget.movie.isFavorite;
    _storage = StorageDatasourceImpl();
  }

  void _addRemoveFav() {
    // 0- actualizar el estado de las pantallas
    Movie? a;
    if (ref.watch(nowPlayingAsync).value != null) {
      a = ref.watch(nowPlayingAsync).value!.firstWhereOrNull((element) => element.id == widget.movie.id);
    }
    Movie? b;
    if (ref.watch(popularAsync).value != null) {
      b = ref.watch(popularAsync).value!.firstWhereOrNull((element) => element.id == widget.movie.id);
    }
    Movie? c;
    if (ref.watch(topRatedAsync).value != null) {
      c = ref.watch(topRatedAsync).value!.firstWhereOrNull((element) => element.id == widget.movie.id);
    }
    Movie? d;
    if (ref.watch(upcomingAsync).value != null) {
      d = ref.watch(upcomingAsync).value!.firstWhereOrNull((element) => element.id == widget.movie.id);
    }

    // 1- setear estado
    setState(() {
      _isFav = !_isFav;
    });

    // 2- cambió a true, agregar
    if (_isFav == true) {
      _storage.saveFavorite(widget.movie.id.toString());
      widget.movie.isFavorite = true;
      if (a != null) a.isFavorite = true;
      if (b != null) b.isFavorite = true;
      if (c != null) c.isFavorite = true;
      if (d != null) d.isFavorite = true;
    }

    // 3- cambió a false, quitar
    if (_isFav == false) {
      _storage.removeFavorite(widget.movie.id.toString());
      widget.movie.isFavorite = false;
      if (a != null) a.isFavorite = false;
      if (b != null) b.isFavorite = false;
      if (c != null) c.isFavorite = false;
      if (d != null) d.isFavorite = false;
    }
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
                    stops: [0.0, 0.2],
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
                  onPressed: () => _addRemoveFav(),
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
