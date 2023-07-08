import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced_seach_provider.dart';

class CategoriesList extends ConsumerStatefulWidget {
  const CategoriesList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CategoriesListState();
}

class _CategoriesListState extends ConsumerState<CategoriesList> {
  @override
  void initState() {
    super.initState();
    ref.read(getCategoriesProvider);
  }

  @override
  Widget build(BuildContext context) {
    var fetchCategoriesProvider = ref.watch(getCategoriesProvider);
    final textStyles = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Seleccione categorias',
            style: textStyles.titleLarge,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: fetchCategoriesProvider.when(
              data: (data) {
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return data[index] != data.last ? const Divider(height: 0) : const SizedBox.shrink();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    bool isInList = ref.watch(selectedCategProvider).contains(data[index].id);
                    //bool isInList = provider.selectedCategories.contains(data[index].id);

                    return _Tile(
                      isSelected: isInList,
                      text: data[index].name,
                      onTap: () {
                        if (!isInList) {
                          ref.read(selectedCategProvider.notifier).update((state) => [...state, data[index].id]);
                        } else {
                          ref.read(selectedCategProvider.notifier).update((state) {
                            var list = [...state];
                            list.remove(data[index].id);
                            return list;
                          });
                        }
                      },
                    );
                  },
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.75,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                text,
                style: textStyles.titleMedium,
              ),
            ),
            Visibility(
              visible: isSelected,
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}
