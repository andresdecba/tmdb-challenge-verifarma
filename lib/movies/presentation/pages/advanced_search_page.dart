import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/helpers/helpers.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/appbar.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/advanced_seach.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_categories.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_keywords.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_persons.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/categories.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/keywords.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/persons.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/years.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/custom_botomsheet.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/custom_chip.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_tile.dart';

class AdvancedSearchPage extends ConsumerStatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<AdvancedSearchPage> {
  late TextEditingController keywordCtlr;
  late TextEditingController fromYearCtlr;
  late TextEditingController toYearCtlr;
  late TextEditingController yearCtlr;

  @override
  void initState() {
    super.initState();
    keywordCtlr = TextEditingController();
    fromYearCtlr = TextEditingController();
    toYearCtlr = TextEditingController();
    yearCtlr = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    keywordCtlr.dispose();
    fromYearCtlr.dispose();
    toYearCtlr.dispose();

    yearCtlr.dispose();
  }

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 2)),
  );

  @override
  Widget build(BuildContext context) {
    var controller = ref.read(advancedSearchAsyncProvider.notifier);
    var provider = ref.watch(advancedSearchAsyncProvider);
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final emptyStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.grey.shade700,
          fontStyle: FontStyle.italic,
        );

    return Scaffold(
      appBar: customAppbar,
      persistentFooterButtons: [
        // BOTON BUSCAR //
        SizedBox(
          width: double.infinity,
          height: 40,
          child: Expanded(
            child: ElevatedButton(
              onPressed: () {
                controller.getData(
                  keyword: Helpers.categoriesListToString(ref.read(selectedKewordsProvider)),
                  categories: Helpers.categoriesListToString(ref.read(selectedCategProvider)),
                  persons: Helpers.categoriesListToString(ref.read(selectedPersonProvider)),
                  year: yearCtlr.text,
                  fromYear: fromYearCtlr.text,
                  toYear: toYearCtlr.text,
                );
                context.pushNamed(AppRoutes.advancedResultsPage);
              },
              child: const Text('Buscar'),
            ),
          ),
        ),
      ],
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // PALABARAS CLAVES //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Palabras claves',
                      style: titleStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => customBottomSheet(
                        context: context,
                        child: const Keywords(),
                      ),
                    ),
                  ],
                ),
                ref.watch(selectedKewordsProvider).isEmpty
                    ? Text('Filtrar por palabras claves', style: emptyStyle)
                    : Wrap(
                        children: List<Widget>.generate(
                          ref.watch(selectedKewordsProvider).length,
                          (int idx) {
                            return CustomChip(
                              text: ref.watch(selectedKewordsProvider)[idx].name,
                              onTap: () {
                                ref.read(selectedKewordsProvider.notifier).update((state) {
                                  var list = [...state];
                                  list.removeAt(idx);
                                  return list;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                const SizedBox(height: 10),
                const Divider(thickness: 1, color: Colors.grey),
              ],
            ),

            // AÑO - RANGO DE AÑOS //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Años',
                      style: titleStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => customBottomSheet(
                        context: context,
                        child: Years(
                          fromYearCtlr: fromYearCtlr,
                          toYearCtlr: toYearCtlr,
                          yearCtlr: yearCtlr,
                        ),
                      ),
                    ),
                  ],
                ),
                (_years() != null)
                    ? CustomChip(
                        text: _years()!,
                        onTap: () => yearCtlr.clear(),
                      )
                    : Text('Filtrar por años', style: emptyStyle),
                const SizedBox(height: 10),
                const Divider(thickness: 1, color: Colors.grey),
              ],
            ),

            // CATEGORIAS //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categorias',
                      style: titleStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => customBottomSheet(
                        context: context,
                        child: const Categories(),
                      ),
                    ),
                  ],
                ),
                ref.watch(selectedCategProvider).isEmpty
                    ? Text('Filtrar por palabras categorias', style: emptyStyle)
                    : Wrap(
                        children: List<Widget>.generate(
                          ref.watch(selectedCategProvider).length,
                          (int idx) {
                            return CustomChip(
                              text: ref.watch(selectedCategProvider)[idx].name,
                              onTap: () {
                                ref.read(selectedCategProvider.notifier).update((state) {
                                  var list = [...state];
                                  list.removeAt(idx);
                                  return list;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                const SizedBox(height: 10),
                const Divider(thickness: 1, color: Colors.grey),
              ],
            ),

            // PERSONAS //
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personas',
                      style: titleStyle,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => customBottomSheet(
                        context: context,
                        child: const Persons(),
                      ),
                    ),
                  ],
                ),
                ref.watch(selectedPersonProvider).isEmpty
                    ? Text('Filtrar por personas', style: emptyStyle)
                    : Wrap(
                        children: List<Widget>.generate(
                          ref.watch(selectedPersonProvider).length,
                          (int idx) {
                            return CustomChip(
                              text: ref.watch(selectedPersonProvider)[idx].name,
                              onTap: () {
                                ref.read(selectedPersonProvider.notifier).update((state) {
                                  var list = [...state];
                                  list.removeAt(idx);
                                  return list;
                                });
                              },
                            );
                          },
                        ).toList(),
                      ),
                const SizedBox(height: 10),
                const Divider(thickness: 1, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 20),

            // RESULTADOS //
            // const SizedBox(height: 20),
            // Visibility(
            //   visible: (provider.value != null),
            //   replacement: const Text(''),
            //   child: provider.when(
            //     loading: () => const Center(child: CircularProgressIndicator()),
            //     error: (error, stackTrace) => Text('Error $error'),
            //     data: (data) {
            //       return Expanded(
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisSize: MainAxisSize.min,
            //           children: [
            //             Text('${data.totalResults.toString()} resultados, ${data.totalPages.toString()} paginas'),
            //             const Divider(color: Colors.white),
            //             Expanded(
            //               child: SingleChildScrollView(
            //                 physics: const BouncingScrollPhysics(),
            //                 child: ListView.builder(
            //                   itemCount: data.results.length,
            //                   shrinkWrap: true,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return MovieTile(
            //                       movie: data.results[index],
            //                       height: 90,
            //                       onMovieSelected: () {
            //                         context.pushNamed(
            //                           AppRoutes.movieDetailsPage,
            //                           extra: data.results[index],
            //                         );
            //                       },
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),
            // ),

            // WIDGET ENDS
          ],
        ),
      ),
    );
  }

  String? _years() {
    if (yearCtlr.text != '') {
      return yearCtlr.text;
    }
    if (fromYearCtlr.text != '' && toYearCtlr.text != '') {
      return '${fromYearCtlr.text} - ${toYearCtlr.text}';
    }
    return null;
  }
}
