import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';

class MyBottomNavigation extends ConsumerWidget {
  const MyBottomNavigation({super.key});

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
      unselectedFontSize: 11,
      selectedFontSize: 11,
      onTap: (value) {
        _onTap(context: context, index: value, ref: ref);
        ref.read(_bottomNavigationBarProvider.notifier).setCurrentIndex(value);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_activity),
          label: 'Now playing',
          activeIcon: Icon(Icons.local_activity),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Popular',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_outlined),
          label: 'Top rated',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Upcoming',
        ),
      ],
    );
  }

  void _onTap({required BuildContext context, required int index, required WidgetRef ref}) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.nowPlayingTab);
        break;
      case 1:
        context.goNamed(AppRoutes.popularTab);
        break;
      case 2:
        context.goNamed(AppRoutes.topRatedTab);
        break;
      case 3:
        context.goNamed(AppRoutes.upcomingTab);
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
