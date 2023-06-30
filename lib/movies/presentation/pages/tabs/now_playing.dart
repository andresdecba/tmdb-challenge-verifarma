import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/movies_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_masonry.dart';

class NowPlayingTab extends ConsumerStatefulWidget {
  const NowPlayingTab({super.key});
  @override
  NowPlayingTabState createState() => NowPlayingTabState();
}

class NowPlayingTabState extends ConsumerState<NowPlayingTab> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingProvider.notifier).nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final nowPlayingWatch = ref.watch(nowPlayingProvider);

    return MoviesGridView(
      movies: nowPlayingWatch,
      loadNextPage: () {
        ref.read(nowPlayingProvider.notifier).nextPage();
      },
    );
  }
}


/*

  List<int> categorias = [28, 12, 16, 35, 80, 99, 18, 10751, 14, 36, 27, 10402, 9648, 10749, 878, 10770, 10752, 37];
GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: 20,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 100,
            width: 100,
            color: Colors.red,
            child: Text(index.toString()),
          );
        },
      ),


curl --request GET \
     --url 'https://api.themoviedb.org/3/genre/movie/list?language=en' \
     --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjNTExM2Q5N2RiMjU2ZTRmZTNiODA1NzcwMDZjMjZkZiIsInN1YiI6IjVlZmIxNTRkNTQzN2Y1MDAzODhkNjBiOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KDSxFmzdPEO3FV13Kh0c6_oD-7IwB0Oll8rnIvcHdyA' \
     --header 'accept: application/json'

  return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //
          HorizontalSlide(
            movies: nowPlayingWatch,
            label: 'Acción',
            loadNextPage: () => ref.read(nowPlayingProvider.notifier).nextPage(),
            onTap: () => print('hola Acción'), //() => context.push('/movie/${movie.id}'),
          ),

          //
          HorizontalSlide(
            movies: nowPlayingWatch,
            label: 'Aventura',
            loadNextPage: () => ref.read(nowPlayingProvider.notifier).nextPage(),
            onTap: () => print('hola Aventura'), //() => context.push('/movie/${movie.id}'),
          ),

          //
          HorizontalSlide(
            movies: nowPlayingWatch,
            label: 'Motivadoras',
            loadNextPage: () => ref.read(nowPlayingProvider.notifier).nextPage(),
            onTap: () => print('hola Motivadoras'), //() => context.push('/movie/${movie.id}'),
          ),
        ],
      ),
    );

*/