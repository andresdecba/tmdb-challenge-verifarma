import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_categories.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/selectable_tile.dart';

class Categories extends ConsumerStatefulWidget {
  const Categories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesListState();
}

class _CategoriesListState extends ConsumerState<Categories> {
  @override
  void initState() {
    super.initState();
    ref.read(getCategoriesProvider);
  }

  @override
  Widget build(BuildContext context) {
    var fetchCategoriesProvider = ref.watch(getCategoriesProvider);

    return Column(
      children: [
        // TITLE //
        const Text(
          'Seleccionar una categoría',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),

        // CATEGORIAS //
        fetchCategoriesProvider.when(
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => Container(
            padding: const EdgeInsets.all(40),
            width: double.infinity,
            child: const Center(child: CircularProgressIndicator()),
          ),
          data: (data) {
            return Expanded(
              child: Scrollbar(
                thickness: 10,
                radius: const Radius.circular(50),
                thumbVisibility: true,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return data[index] != data.last ? const Divider(height: 0) : const SizedBox.shrink();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      bool isInList = ref.watch(selectedCategProvider).contains(data[index]);
                      //bool isInList = provider.selectedCategories.contains(data[index].id);

                      return SelectableTile(
                        isSelected: isInList,
                        text: data[index].name,
                        onTap: () {
                          if (!isInList) {
                            ref.read(selectedCategProvider.notifier).update((state) => [...state, data[index]]);
                          } else {
                            ref.read(selectedCategProvider.notifier).update((state) {
                              var list = [...state];
                              list.remove(data[index]);
                              return list;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
