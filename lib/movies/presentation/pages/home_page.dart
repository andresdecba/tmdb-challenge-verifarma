import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tmdb_challenge/core/routes/routes.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: SvgPicture.asset(
          'assets/tmdb_logo.svg',
          height: 15,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => context.goNamed(AppRoutes.favoritesPage),
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: const MyBottomNavigation(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: widget.child,
      ),
    );
  }
}


/*
optional appbar
PreferredSize(
        preferredSize: const Size(double.infinity, 100),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/tmdb_logo.svg',
                  height: 15,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite),
                ),
              ],
            ),
          ),
        ),
      ),
*/