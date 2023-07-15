import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

class HorizontalListView extends StatefulWidget {
  final List<Movie> movies;
  final VoidCallback onNavigate;

  const HorizontalListView({
    super.key,
    required this.movies,
    required this.onNavigate,
  });

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  // final scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   scrollController.addListener(() {
  //     if (widget.loadNextPage == null) return;
  //     if ((scrollController.position.pixels + 100) >= scrollController.position.maxScrollExtent) {
  //       widget.loadNextPage!();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: widget.movies.length + 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        //controller: scrollController,
        itemBuilder: (context, index) {
          // VER TODAS
          if (index == widget.movies.length) {
            return InkWell(
              onTap: () => widget.onNavigate(),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF90CEA1),
                      Color(0XFF01b4e4),
                    ],
                  ),
                ),
                child: const AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Center(
                    child: Text('ver todas'),
                  ),
                ),
              ),
            );
          }

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
