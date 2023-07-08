import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/movies/presentation/providers/advanced_seach_provider.dart';

// StateProvider that can be watched by other widgets to obtain the
// current search query.

// final moviesSearchTextProvider = StateProvider<String>((ref) {
//   return '';
// });

class MoviesSearchBar extends ConsumerStatefulWidget {
  const MoviesSearchBar({Key? key}) : super(key: key);

  @override
  ConsumerState<MoviesSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<MoviesSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Timer? _debounceTimer;
  void cancelTimer() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 10),
                Expanded(
                  child: Center(
                    child: TextField(
                      controller: _controller,
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
                          ref.read(getPersonsProvider.notifier).onDataChange(query: _controller.text);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
