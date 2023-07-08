import 'package:equatable/equatable.dart';

class MovieCategory extends Equatable {
  final int id;
  final String name;

  const MovieCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() {
    return 'id: $id name: $name, ';
  }
}
