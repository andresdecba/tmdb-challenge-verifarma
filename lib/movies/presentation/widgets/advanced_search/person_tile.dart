import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_challenge/movies/domain/entities/person_details.dart';
import 'package:tmdb_challenge/movies/presentation/widgets/movie_poster.dart';

class PersonTile extends StatelessWidget {
  final PersonDetails person;
  final double? height;
  final VoidCallback? onPersonSelected;

  const PersonTile({
    super.key,
    required this.person,
    this.height,
    this.onPersonSelected,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return InkWell(
      onTap: (onPersonSelected != null) ? () => onPersonSelected!() : null,
      child: FadeIn(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              MoviePoster(
                posterPath: person.profilePath,
                height: height ?? 120,
              ),

              const SizedBox(width: 10),

              // Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name,
                      style: textStyles.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      person.knownForDepartment,
                      style: textStyles.bodyMedium!.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
