import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced_seach_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/categories_list.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/persons_list.dart';

class AdvancedSearchPage extends ConsumerStatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends ConsumerState<AdvancedSearchPage> {
  late TextEditingController keywordCtlr;
  late TextEditingController fromYearCtlr;
  late TextEditingController toYearCtlr;
  late TextEditingController peopleCtlr;
  late TextEditingController yearCtlr;
  late GlobalKey<FormState> searchFormStateKey;

  @override
  void initState() {
    super.initState();
    keywordCtlr = TextEditingController();
    fromYearCtlr = TextEditingController();
    toYearCtlr = TextEditingController();
    peopleCtlr = TextEditingController();
    yearCtlr = TextEditingController();
    searchFormStateKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    super.dispose();
    keywordCtlr.dispose();
    fromYearCtlr.dispose();
    toYearCtlr.dispose();
    peopleCtlr.dispose();
    yearCtlr.dispose();
  }

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 2)),
  );

  @override
  Widget build(BuildContext context) {
    var provider = ref.read(advancedSearchAsyncProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('search page')),

      // BOTON BUSCAR //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ElevatedButton(
            onPressed: () => provider.getData(
              selectedCategories: ref.watch(selectedCategProvider),
              fromYear: fromYearCtlr.text,
              toYear: toYearCtlr.text,
              keyword: keywordCtlr.text,
              year: yearCtlr.text,
            ),
            child: Text('Buscar'),
          );
        },
      ),

      //
      body: Form(
        key: searchFormStateKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // KEYWORD
              TextFormField(
                controller: keywordCtlr,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  labelText: 'Palabra clave',
                  hintText: 'ej: "El padrino"',
                  sufixIcon: Icons.clear_rounded,
                  onTap: () => keywordCtlr.clear(),
                ),
                //validator: (value) => value != null ? 'Ingrese un valor' : null,
              ),

              // PERSONA
              const SizedBox(height: 10),
              TextFormField(
                controller: peopleCtlr,
                keyboardType: TextInputType.text,
                decoration: _inputDecoration(
                  labelText: 'Persona',
                  hintText: 'Christopher Nolan',
                  sufixIcon: Icons.clear_rounded,
                  onTap: () => keywordCtlr.clear(),
                ),
                //validator: (value) => value != null ? 'Ingrese un valor' : null,
              ),

              // UN SOLO AÑO
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Buscar por un año en particular'),
              ),
              TextFormField(
                controller: yearCtlr,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  labelText: 'Año',
                  hintText: 'ej: 1994',
                  sufixIcon: Icons.clear_rounded,
                  onTap: () => keywordCtlr.clear(),
                ),
                //validator: (value) => value != null ? 'Ingrese un valor' : null,
              ),

              // DATES RANGE
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Buscar por un rango de años'),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: fromYearCtlr,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        labelText: 'Desde el año',
                        hintText: 'ej: 2005',
                        sufixIcon: Icons.clear_rounded,
                        onTap: () => keywordCtlr.clear(),
                      ),
                      //validator: (value) => value != null ? 'Ingrese un valor' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: toYearCtlr,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        labelText: 'Hasta el año',
                        hintText: 'ej: 2010',
                        sufixIcon: Icons.clear_rounded,
                        onTap: () => keywordCtlr.clear(),
                      ),
                      //validator: (value) => value != null ? 'Ingrese un valor' : null,
                    ),
                  ),
                ],
              ),

              // CATEGORIAS
              const SizedBox(height: 10),
              const Text('Agregar categorias'),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _openCategories(),
                    child: Text('Agregar categoria'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: List<Widget>.generate(
                        ref.watch(selectedCategProvider).length,
                        (int idx) {
                          return ChoiceChip(
                              padding: const EdgeInsets.all(8),
                              labelPadding: const EdgeInsets.all(8),
                              label: Text(ref.watch(selectedCategProvider)[idx].toString()),
                              selected: true,
                              avatar: const Icon(Icons.close),
                              onSelected: (bool selected) {
                                ref.read(selectedCategProvider.notifier).update((state) {
                                  var list = [...state];
                                  list.removeAt(idx);
                                  return list;
                                });
                              });
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),

              // BUSCAR GENTE
              const SizedBox(height: 10),
              const Text('Agregar persona'),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _openSearchPersons(),
                    child: Text('Agregar persona'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      children: List<Widget>.generate(
                        ref.watch(selectedPersonProvider).length,
                        (int idx) {
                          return ChoiceChip(
                              padding: const EdgeInsets.all(8),
                              labelPadding: const EdgeInsets.all(8),
                              label: Text(ref.watch(selectedPersonProvider)[idx].toString()),
                              selected: true,
                              avatar: const Icon(Icons.close),
                              onSelected: (bool selected) {
                                ref.read(selectedPersonProvider.notifier).update((state) {
                                  var list = [...state];
                                  list.removeAt(idx);
                                  return list;
                                });
                              });
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCategories() {
    showModalBottomSheet(
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isDismissible: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const CategoriesList();
      },
    );
  }

  void _openSearchPersons() {
    showModalBottomSheet(
      constraints: BoxConstraints.loose(
        Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height * 0.75,
        ),
      ),
      isDismissible: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return const PersonsList();
      },
    );
  }

  InputDecoration _inputDecoration({
    required String labelText,
    required String hintText,
    required VoidCallback onTap,
    required IconData sufixIcon,
  }) {
    const double radius = 5;
    return InputDecoration(
      // regular borders
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan.shade800, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan.shade800, width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
      ),
      // error borders
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade800, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(radius)),
      ),
      // other properties
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      labelText: labelText,
      hintText: hintText,
      suffixIcon: IconButton(
        onPressed: () => onTap(),
        icon: Icon(sufixIcon),
      ),
    );
  }
}
