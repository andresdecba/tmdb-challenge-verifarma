import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/domain/entities/movie.dart';
import 'package:tmdb_challenge/movies/presentation/providers/search_by_title_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/custom_textfield.dart';

class SearchMovieByTitlePage extends ConsumerStatefulWidget {
  const SearchMovieByTitlePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchByTitlePageState();
}

class _SearchByTitlePageState extends ConsumerState<SearchMovieByTitlePage> {
  late TextEditingController txtCtrlr;
  final pageCtlr = PageController();
  bool isTxtFieldEmpty = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    txtCtrlr = TextEditingController();
    txtCtrlr.addListener(() {
      setState(() {
        txtCtrlr.text.isEmpty ? isTxtFieldEmpty = true : isTxtFieldEmpty = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    txtCtrlr.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesRead = ref.read(searchByTitleProvider.notifier);
    final moviesWatch = ref.watch(searchByTitleProvider);
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      // APPBAR //
      appBar: AppBar(
        title: CustomTextField(
          txtController: txtCtrlr,
          hintText: 'Buscar por título',
          onChange: (text) => moviesRead.onQueryChanged(text, currentPage),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            ),
          ),
        ),
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
      ),

      // BODY //
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Visibility(
          visible: !isTxtFieldEmpty,
          replacement: const Expanded(
            child: Center(
              child: Text('Buscar una pelírcula por su título.'),
            ),
          ),
          child: moviesWatch.when(
            data: (data) {
              // BUILD PAGE
              return PageView.builder(
                itemCount: data.totalPages,
                controller: pageCtlr,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                // CHANGE
                onPageChanged: (value) {
                  currentPage++;
                  moviesRead.onQueryChanged(txtCtrlr.text, currentPage);
                },
                // BUILD
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${data.totalResults} resultados',
                                  style: textStyles.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Página ${data.page} de  ${data.totalPages}',
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

                      // BUILD RESULTS //
                      Expanded(
                        child: SingleChildScrollView(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(color: Colors.grey),
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.results.length,
                            itemBuilder: (BuildContext context, int index) {
                              final Movie title = data.results[index];
                              return _TilteTile(
                                onTap: () => context.pushNamed(AppRoutes.movieDetailsPage, extra: title),
                                title: title.title,
                                year: title.releaseDate != null ? title.releaseDate!.year.toString() : null,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            error: (error, stackTrace) => Text('error $error'),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class _TilteTile extends StatelessWidget {
  const _TilteTile({
    required this.title,
    required this.year,
    required this.onTap,
  });

  final String title;
  final String? year;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$title.',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 20),
              if (year != null)
                Text(
                  ' ($year)',
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          )),
    );
  }
}
