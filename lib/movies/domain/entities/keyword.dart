import 'package:equatable/equatable.dart';

class Keyword extends Equatable {
  final int id;
  final String name;

  const Keyword({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  @override
  String toString() {
    return 'id: $id, name: $name';
  }
}
