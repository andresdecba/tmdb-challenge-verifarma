import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';

class Paginator extends ConsumerStatefulWidget {
  const Paginator({
    required this.title,
    required this.onPageChanged,
    required this.itemBuilder,
    super.key,
  });

  final String title;
  final ItemBuilder itemBuilder;
  final OnPageChanged onPageChanged;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PaginatorState();
}

class _PaginatorState extends ConsumerState<Paginator> {
  late PageController pageCtlr;

  @override
  void initState() {
    super.initState();
    pageCtlr = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageCtlr.dispose();
  }

  int currentPage = 1;
  int totalPages = 20;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return Scaffold(
      appBar: customAppbar,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// HEADER ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_left_sharp,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.title,
                        style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Página $currentPage de $totalPages',
                        style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_sharp,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: PageView.builder(
                controller: pageCtlr,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                // CHANGE
                onPageChanged: (value) {
                  // widget.onPageChanged(value);
                  // setState(() {
                  //   currentPage = value + 1;
                  // });
                },
                // BUILD
                itemBuilder: (context, index) {
                  // return movies.when(
                  //   data: (data) {
                  //     totalPages = data.totalPages;

                  //     return MoviesGridView(
                  //       movies: data.results,
                  //       loadNextPage: () {},
                  //     );
                  //   },
                  //   error: (error, stackTrace) => Text(error.toString()),
                  //   loading: () => const Center(
                  //     child: CircularProgressIndicator(),
                  //   ),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef ItemBuilder = void Function(BuildContext context, int index);
typedef OnPageChanged = void Function(int value);
