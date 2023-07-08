import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced_seach_provider.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/person_tile.dart';

class PersonsList extends ConsumerStatefulWidget {
  const PersonsList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonssssState();
}

class _PersonssssState extends ConsumerState<PersonsList> {
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

    return Column(
      children: [
        // CAMPO TXT //
        SizedBox(
          height: 70,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: _txtController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintText: 'Search person',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                          ),
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (text) {
                            cancelTimer();
                            _debounceTimer = Timer(const Duration(milliseconds: 666), () async {
                              ref.read(getPersonsProvider.notifier).onDataChange(query: _txtController.text);
                            });
                            providerCtlr.currentSearchValue = _txtController.text;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // RESULTADOS //

        Visibility(
          visible: (provider.isLoading || provider.value!.isNotEmpty),
          replacement: const Center(child: Text('Buscar una persona')),
          child: ref.watch(getPersonsProvider).when(
                error: (error, stackTrace) => Text('error $error'),
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (data) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                              bool isInList = ref.watch(selectedPersonProvider).contains(data[index].id);

                              return InkWell(
                                onTap: () {
                                  if (!isInList) {
                                    ref.read(selectedPersonProvider.notifier).update((state) => [...state, data[index].id]);
                                  } else {
                                    ref.read(selectedPersonProvider.notifier).update((state) {
                                      var list = [...state];
                                      list.remove(data[index].id);
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
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }
}
