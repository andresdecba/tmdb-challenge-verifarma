import 'package:equatable/equatable.dart';

class PersonDetails extends Equatable {
  final int id;
  final String knownForDepartment;
  final String name;
  final String? profilePath;

  const PersonDetails({
    required this.id,
    required this.knownForDepartment,
    required this.name,
    this.profilePath,
  });

  @override
  List<Object?> get props => [id, name];
}
