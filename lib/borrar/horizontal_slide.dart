// import 'package:flutter/material.dart';
// import 'package:animate_do/animate_do.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tmdb_challenge/core/routes/routes.dart';
// import 'package:tmdb_challenge/movies/domain/entities/movie.dart';

// class HorizontalSlide extends StatefulWidget {
//   final List<Movie> movies;
//   final String label;
//   final VoidCallback loadNextPage;
//   final VoidCallback? onTap;

//   const HorizontalSlide({
//     super.key,
//     required this.movies,
//     required this.label,
//     required this.loadNextPage,
//     this.onTap,
//   });

//   @override
//   State<HorizontalSlide> createState() => _HorizontalSlideState();
// }

// class _HorizontalSlideState extends State<HorizontalSlide> {
//   final scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     scrollController.addListener(() {
//       if ((scrollController.position.pixels + 200) >= scrollController.position.maxScrollExtent) {
//         widget.loadNextPage();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textStyle = Theme.of(context).textTheme;

//     return Container(
//       height: 200,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: Text(
//               widget.label,
//               style: textStyle.titleLarge,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Expanded(
//             child: ListView.builder(
//               controller: scrollController,
//               itemCount: widget.movies.length,
//               scrollDirection: Axis.horizontal,
//               physics: const BouncingScrollPhysics(),
//               shrinkWrap: true,
//               itemBuilder: (context, index) {
//                 return FadeInRight(
//                   child: _Item(
//                     movie: widget.movies[index],
//                     onTap: () {
//                       context.pushNamed(
//                         AppRoutes.movieDetailsPage,
//                         extra: widget.movies[index],
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Item extends StatelessWidget {
//   const _Item({
//     required this.movie,
//     this.onTap,
//   });
//   final Movie movie;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(right: 8),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.all(Radius.circular(5)),
//             child: Image.network(
//               alignment: Alignment.center,
//               movie.posterPath,
//               fit: BoxFit.cover,
//               width: 100,
//               height: 150,
//               loadingBuilder: (context, child, loadingProgress) {
//                 if (loadingProgress != null) {
//                   return const SizedBox(
//                     width: 100,
//                     height: 150,
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 }
//                 return GestureDetector(
//                   onTap: () => onTap!(),
//                   child: FadeIn(
//                     child: child,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
