import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_persons.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/custom_textfield.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/person_tile.dart';

class Persons extends ConsumerStatefulWidget {
  const Persons({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonsState();
}

class _PersonsState extends ConsumerState<Persons> {
  final _scrollController = ScrollController();
  final _txtController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    if (ref.read(getPersonsProvider.notifier).currentSearchValue != '') {
      _txtController.text = ref.read(getPersonsProvider.notifier).currentSearchValue;
    }

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels + 100) >= _scrollController.position.maxScrollExtent) {
        cancelTimer();
        _debounceTimer = Timer(const Duration(milliseconds: 666), () async {
          ref.read(getPersonsProvider.notifier).nextPage();
          ref.read(getPersonsProvider.notifier).onDataChange(query: _txtController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _txtController.dispose();
    cancelTimer();
  }

  void cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var provider = ref.watch(getPersonsProvider);
    var providerCtlr = ref.read(getPersonsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TITLE //
          const Text(
            'Buscar y agregar una persona o más perosnas,\n(busque de a una por vez)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // CAMPO TXT //
          CustomTextField(
            txtController: _txtController,
            hintText: 'ej: Christian Bale',
            onChange: (text) {
              cancelTimer();
              _debounceTimer = Timer(const Duration(milliseconds: 666), () async {
                ref.read(getPersonsProvider.notifier).onDataChange(query: _txtController.text);
              });
              providerCtlr.currentSearchValue = _txtController.text;
            },
          ),
          const SizedBox(height: 20),

          // RESULTADOS //
          Visibility(
            visible: (provider.isLoading || provider.value!.isNotEmpty),
            //replacement: const Center(child: Text('Buscar y agregar actores, directores, etc...')),
            child: ref.watch(getPersonsProvider).when(
                  error: (error, stackTrace) => Text('error $error'),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(),
                  ),
                  data: (data) {
                    return Expanded(
                      child: Scrollbar(
                        thickness: 10,
                        radius: const Radius.circular(50),
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              //
                              bool isInList = ref.watch(selectedPersonProvider).contains(data[index]);

                              return InkWell(
                                onTap: () {
                                  if (!isInList) {
                                    ref.read(selectedPersonProvider.notifier).update((state) => [...state, data[index]]);
                                  } else {
                                    ref.read(selectedPersonProvider.notifier).update((state) {
                                      var list = [...state];
                                      list.remove(data[index]);
                                      return list;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: PersonTile(
                                        height: 70,
                                        person: data[index],
                                      ),
                                    ),
                                    Visibility(
                                      visible: isInList,
                                      child: const Icon(Icons.check),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
