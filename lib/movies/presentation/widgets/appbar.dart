import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

var customAppbar = AppBar(
  backgroundColor: Colors.black.withOpacity(0.5),
  title: SvgPicture.asset(
    'assets/tmdb_logo.svg',
    height: 15,
  ),
  centerTitle: true,
);
