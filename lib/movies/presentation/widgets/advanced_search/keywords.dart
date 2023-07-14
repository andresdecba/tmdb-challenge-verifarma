import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced-search/get_keywords.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/custom_textfield.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/advanced_search/selectable_tile.dart';

class Keywords extends ConsumerStatefulWidget {
  const Keywords({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KeywordsState();
}

class _KeywordsState extends ConsumerState<Keywords> {
  final _scrollController = ScrollController();
  final _txtController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    if (ref.read(getKeywordsProvider.notifier).currentSearchValue != '') {
      _txtController.text = ref.read(getKeywordsProvider.notifier).currentSearchValue;
    }

    _scrollController.addListener(() {
      if ((_scrollController.position.pixels + 100) >= _scrollController.position.maxScrollExtent) {
        cancelTimer();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
          ref.read(getKeywordsProvider.notifier).nextPage();
          ref.read(getKeywordsProvider.notifier).onDataChange(query: _txtController.text);
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
    var provider = ref.watch(getKeywordsProvider);
    var providerCtlr = ref.read(getKeywordsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // TITLE //
          const Text(
            'Buscar y agregar una o más palabras claves,\n(busque de a una por vez)', //
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // CAMPO TXT //
          CustomTextField(
            txtController: _txtController,
            hintText: 'ej: dark night',
            onChange: (text) {
              cancelTimer();
              _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
                ref.read(getKeywordsProvider.notifier).onDataChange(query: _txtController.text);
              });
              providerCtlr.currentSearchValue = _txtController.text;
            },
          ),
          const SizedBox(height: 20),

          // RESULTADOS //
          Visibility(
            visible: (provider.isLoading || provider.value!.isNotEmpty),
            //replacement: const SizedBox(),
            child: ref.watch(getKeywordsProvider).when(
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
                              bool isInList = ref.watch(selectedKewordsProvider).contains(data[index]);

                              return SelectableTile(
                                text: data[index].name,
                                isSelected: isInList,
                                onTap: () {
                                  if (!isInList) {
                                    ref.read(selectedKewordsProvider.notifier).update((state) => [...state, data[index]]);
                                  } else {
                                    ref.read(selectedKewordsProvider.notifier).update((state) {
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
          ),
        ],
      ),
    );
  }
}
