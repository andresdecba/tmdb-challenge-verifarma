import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: SvgPicture.asset(
          'assets/tmdb_logo.svg',
          height: 15,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.home),
        //   ),
        // ],
      ),
      extendBodyBehindAppBar: true,
      body: const Center(
        child: Text('FAVORITOS'),
      ),
    );
  }
}
