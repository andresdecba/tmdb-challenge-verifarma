import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final double? height;
  final String posterPath;
  final VoidCallback? onTap;

  const MoviePoster({
    super.key,
    this.height,
    required this.posterPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random();

    return FadeInUp(
      from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: onTap != null ? () => onTap : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: FadeInImage(
            height: height ?? 180,
            fit: BoxFit.cover,
            placeholder: const AssetImage('assets/bottle-loader.gif'),
            image: NetworkImage(posterPath),
          ),
        ),
      ),
    );
  }
}
