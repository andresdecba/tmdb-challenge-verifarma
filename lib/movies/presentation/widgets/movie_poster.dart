import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MoviePoster extends StatelessWidget {
  final double? height;
  final String? posterPath;
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

    return FadeIn(
      //from: random.nextInt(100) + 80,
      delay: Duration(milliseconds: random.nextInt(450) + 0),
      child: GestureDetector(
        onTap: (onTap != null) ? () => onTap!() : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: posterPath != null
              ? SizedBox(
                  height: height ?? 180,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: CachedNetworkImage(
                      imageUrl: posterPath!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset('assets/bottle-loader.gif'),
                    ),
                  ),
                )
              : SizedBox(
                  height: height ?? 180,
                  child: const AspectRatio(
                    aspectRatio: 2 / 3,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/bottle-loader.gif'),
                      image: AssetImage('assets/no-image.png'),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
