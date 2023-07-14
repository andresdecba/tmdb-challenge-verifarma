import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/providers/favorites_provider.dart';

class BottomNavigation extends ConsumerWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    int currentIndex = ref.watch(_bottomNavigationBarProvider);
    //
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      currentIndex: currentIndex,
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.grey[800],
      selectedItemColor: Colors.white,
      //unselectedFontSize: 9,
      selectedFontSize: 11,
      iconSize: 20,
      onTap: (value) {
        _onTap(context: context, index: value, ref: ref);
        ref.read(_bottomNavigationBarProvider.notifier).setCurrentIndex(value);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'My favorites',
        ),
      ],
    );
  }

  void _onTap({required BuildContext context, required int index, required WidgetRef ref}) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.homePage);
        break;
      case 1:
        context.pushNamed(AppRoutes.favoritesPage);
        ref.read(favoriteProviderAsync.notifier).getFavorites();
        break;
    }
  }
}

/// controller ///

final _bottomNavigationBarProvider = StateNotifierProvider<_BottomNavigationBarController, int>(
  (ref) => _BottomNavigationBarController(0),
);

class _BottomNavigationBarController extends StateNotifier<int> {
  _BottomNavigationBarController(super.state);

  void setCurrentIndex(int value) {
    state = value;
  }
}
